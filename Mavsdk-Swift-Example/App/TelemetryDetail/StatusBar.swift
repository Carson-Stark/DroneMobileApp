//
//  StatusBar.swift
//  MAVSDK_Swift_Example
//
//  Created by Carson Stark on 12/21/23.
//

import SwiftUI

struct StatusBar: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var mavsdk = mavsdkDrone
    @ObservedObject var network = tcpClient
    @ObservedObject var statusBarModel = StatusBarModel()
    
    var body: some View {
        HStack {
            Image(systemName: "circlebadge.fill")
                .foregroundColor(mavsdk.isConnected ? .green : .red )
                .padding(.leading, 5)
            Text("MavLink")
                .font(.system(size: 12.0, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
                .padding(5)
            
            Image(systemName: "circlebadge.fill")
                .foregroundColor(network.isConnected ? .green : .red )
                .padding(.leading, 5)
            Text("TCP")
                .font(.system(size: 12.0, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
                .padding(5)
            
            if mavsdk.isConnected && statusBarModel.armed {
                Text("Mode: " + statusBarModel.flightMode)
                    .font(.system(size: 12.0, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(5)
                    .padding(.trailing, 10)
            }
            else {
                Image(systemName: "circlebadge.fill")
                    .foregroundColor(statusBarModel.armable ? .green : .red )
                    .padding(.leading, 5)
                Text("Armable")
                    .font(.system(size: 12.0, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(5)
                    .padding(.trailing, 5)
            }
        }
        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.9501284247)) : Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.95)))
        .cornerRadius(10.0)
        .padding(.all, 5)
    }
}

struct StatusBar_Previews: PreviewProvider {
    static var previews: some View {
        StatusBar()
    }
}
