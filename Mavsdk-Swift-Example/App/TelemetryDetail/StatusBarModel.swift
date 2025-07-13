//
//  StatusBarModel.swift
//  MAVSDK_Swift_Example
//
//  Created by Carson Stark on 12/21/23.
//

import Foundation
import RxSwift
import Mavsdk
import Combine

final class StatusBarModel: ObservableObject {
    @Published private(set) var flightMode = "N/A"
    @Published private(set) var armed = false
    @Published private(set) var armable = false
    
    let disposeBag = DisposeBag()
    var droneCancellable = AnyCancellable {}
    
    init() {
        self.droneCancellable = mavsdkDrone.$drone.compactMap{ $0 }
            .sink{ [weak self] (drone) in
                self?.observeDroneTelemetry(drone: drone)
            }
    }
    
    func observeDroneTelemetry(drone: Drone) {
        drone.telemetry.flightMode
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (mode) in
                self?.flightMode = String(describing: mode)
            })
            .disposed(by: disposeBag)
        
        drone.telemetry.armed
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (armed) in
                self?.armed = armed
            })
            .disposed(by: disposeBag)
        
        drone.telemetry.health
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (health) in
                self?.armable = health.isArmable
            })
            .disposed(by: disposeBag)
    }
}

