//
//  TelemetryDetailViewModel.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 21/05/21.
//

import Foundation
import RxSwift
import Mavsdk
import Combine

final class TelemetryDetailViewModel: ObservableObject {
    @Published private(set) var altitude: Double = 0
    @Published private(set) var battery: Double = 0
    @Published private(set) var velocity: Double = 0
    @Published private(set) var photosTaken = 0
    @Published private(set) var missionProgressCurrent: Double = 0
    @Published private(set) var missionProgressTotal: Double = 0
    
    let disposeBag = DisposeBag()
    var droneCancellable = AnyCancellable {}
    
    init() {
        self.droneCancellable = mavsdkDrone.$drone.compactMap{$0}
            .sink{ [weak self] drone in
                self?.observeDroneTelemetry(drone: drone)
                self?.observeMissionProgress(drone: drone)
                self?.observeCameraUpdates(drone: drone)
            }
    }
    
    func observeDroneTelemetry(drone: Drone) {
        drone.telemetry.position
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (position) in
                self?.altitude = round(Double(position.relativeAltitudeM) * 10) / 10
            })
            .disposed(by: disposeBag)
        
        drone.telemetry.velocityNed
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (info) in
                let velocityX = Double(info.eastMS)
                let velocityY = Double(info.northMS)
                self?.velocity = round(sqrt(pow(velocityX, 2) + pow(velocityY, 2)) * 10) / 10
            })
            .disposed(by: disposeBag)
        
        drone.telemetry.battery
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (info) in
                self?.battery = round(Double(info.voltageV) * 100) / 100
            })
            .disposed(by: disposeBag)
        
        drone.telemetry.statusText
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (info) in
                MessageViewModel.shared.message = info.text
            })
            .disposed(by: disposeBag)
    }
    
    func observeCameraUpdates(drone: Drone) {
        drone.camera.captureInfo
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (info) in
                self?.photosTaken = Int(info.index)
            })
            .disposed(by: disposeBag)

    }
    
    func observeMissionProgress(drone: Drone) {
        drone.mission.missionProgress
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (progress) in
                self?.missionProgressCurrent = Double(progress.current)
                self?.missionProgressTotal = Double(progress.total)
            })
            .disposed(by: disposeBag)
    }
}
