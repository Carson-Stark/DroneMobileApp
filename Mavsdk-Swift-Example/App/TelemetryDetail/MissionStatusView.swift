//
//  MissionStatus.swift
//  MAVSDK_Swift_Example
//
//  Created by Carson Stark on 12/22/23.
//

import SwiftUI

struct MissionStatusView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var missionTime: String = ""
    @State private var currItemTime: String = ""
    @ObservedObject var network = tcpClient
    
    var body: some View {
        if network.missionName != "None" {
            VStack (alignment: .leading) {
                Text("Current Mission: " + network.missionName)
                    .padding([.leading, .trailing, .top], 10)
                    .padding(.bottom, 1)
                    .font(.system(size: 10.0, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                
                Text(missionTime + " - " + currItemTime)
                    .font(.system(size: 10.0, weight: .semibold, design: .monospaced))
                    .padding(.horizontal, 10)
                    .padding(/*@START_MENU_TOKEN@*/.bottom, 1.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                Text(network.missionItems[0])
                    .font(.system(size: 10.0, weight: .semibold, design: .monospaced))
                    .padding([.leading, .trailing], 10)
                    .padding(.bottom, 1)
                    .foregroundColor(.blue)
                Text(network.missionItems[1])
                    .font(.system(size: 10.0, weight: .semibold, design: .monospaced))
                    .padding([.leading, .trailing], 10)
                    .padding(.bottom, 1)
                    .foregroundColor(.gray)
                Text(network.missionItems[2])
                    .font(.system(size: 10.0, weight: .semibold, design: .monospaced))
                    .padding([.leading, .trailing], 10)
                    .padding(.bottom, 10.0)
                    .foregroundColor(.gray)
            }
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.9501284247)) : Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.95)))
            .cornerRadius(10.0)
            .onAppear {
                // Update the time initially
                updateTime()

                // Set up a timer to update the time every second
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    updateTime()
                }
            }
        }
    }
    
    private func calculateTimeElapsed(from startTime: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(startTime)
        let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateTime() {
        missionTime = calculateTimeElapsed(from: network.missionStartTime)
        
        currItemTime = calculateTimeElapsed(from: network.currItemStartTime)
    }
}

struct MissionStatus_Previews: PreviewProvider {
    static var previews: some View {
        MissionStatusView()
    }
}
