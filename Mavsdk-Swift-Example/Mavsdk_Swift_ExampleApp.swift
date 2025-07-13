//
//  Mavsdk_Swift_ExampleApp.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 13/05/21.
//

import SwiftUI

var mavsdkDrone = MavsdkDrone()
var locationManager = LocationManager()
var tcpClient = TCPClient()

@main
struct Mavsdk_Swift_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        application.isStatusBarHidden = true
        return true
    }
}
