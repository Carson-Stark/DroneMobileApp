//
//  ActionsViewModel.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 14/05/21.
//

import Foundation
import Mavsdk
import RxSwift
import Network

final class ActionsViewModel: ObservableObject {
    let drone = mavsdkDrone.drone
    let mapViewModel = MapViewCoordinator.shared.mapView
    let disposeBag = DisposeBag()
    
    var actions: [Action] {
        return [
            Action(text: "Pickup Poop", action: pickupAction),
            Action(text: "Land on Bag", action: landBagAction),
            Action(text: "Fly to Position", action: summonAction),
            Action(text: "Safe Land", action: safeLandAction),
            Action(text: "Safe RTL", action: safeRTLAction),
            Action(text: "Loiter", action: loiterAction),
            Action(text: "Gripper", action: gripperAction),
            Action(text: "Arm", action: armAction),
            Action(text: "TakeOff", action: takeOffAction),
            Action(text: "Land", action: landAction),
            Action(text: "RTL", action: rtlAction),
            Action(text: "Disarm", action: disarmAction),
            Action(text: "Reboot", action: rebootAction),
            Action(text: "Terminate", action: terminateAction),
            //Action(text: "Set RTL Altitude", action: setRTLAltitude)
        ]
    }
    
    init() {}
    
    func armAction() {
        drone?.action.arm()
            .subscribe {
                MessageViewModel.shared.message = "Armed Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Arming: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func disarmAction() {
        drone?.action.disarm()
            .subscribe {
                MessageViewModel.shared.message = "Disarmed Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Disarming: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func takeOffAction() {
        drone?.action.takeoff()
            .subscribe {
                MessageViewModel.shared.message = "Taking Off Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Taking Off: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func landAction() {
        drone?.action.land()
            .subscribe {
                MessageViewModel.shared.message = "Landing Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Landing: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func rtlAction() {
        drone?.action.returnToLaunch()
            .subscribe {
                MessageViewModel.shared.message = "RTL Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error RTL: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func setRTLAltitude() {
        drone?.action.setReturnToLaunchAltitude(relativeAltitudeM: 40)
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "Set RTL Altitude 40m Success"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Setting RTL Altitude: \(error)"
            })
            .disposed(by: disposeBag)
    }
    
    func pickupAction() {
        if tcpClient.isConnected {
            let latitude = mapViewModel.userLocation.coordinate.latitude
            let longitude = mapViewModel.userLocation.coordinate.longitude
            print(latitude)
            print(longitude)
            tcpClient.sendMessage("Pickup \(latitude) \(longitude)");
            MessageViewModel.shared.message = "Sent Pickup Poop Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func landBagAction() {
        if tcpClient.isConnected {
            tcpClient.sendMessage("Search");
            MessageViewModel.shared.message = "Sent Search Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func summonAction() {
        if tcpClient.isConnected {
            let latitude = mapViewModel.userLocation.coordinate.latitude
            let longitude = mapViewModel.userLocation.coordinate.longitude
            print(latitude)
            print(longitude)
            tcpClient.sendMessage("Summon \(latitude) \(longitude)");
            MessageViewModel.shared.message = "Sent Summon Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func gripperAction() {
        if tcpClient.isConnected {
            tcpClient.sendMessage("Gripper");
            MessageViewModel.shared.message = "Sent Gripper Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func loiterAction() {
        drone?.action.hold()
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "Loiter Success"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Switching to Loiter"
            })
            .disposed(by: disposeBag)
    }
    
    func safeLandAction() {
        if tcpClient.isConnected {
            tcpClient.sendMessage("SafeLand");
            MessageViewModel.shared.message = "Sent SafeLand Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func safeRTLAction() {
        if tcpClient.isConnected {
            tcpClient.sendMessage("SafeRTL");
            MessageViewModel.shared.message = "Sent SafeRTL Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func rebootAction() {
        if tcpClient.isConnected {
            tcpClient.sendMessage("Reboot");
            MessageViewModel.shared.message = "Sent Reboot Command!"
        }
        else {
            MessageViewModel.shared.message = "Not Connected!"
        }
    }
    
    func terminateAction() {
        drone?.action.terminate()
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "Terminate Success"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Terminating"
            })
            .disposed(by: disposeBag)
    }
}
