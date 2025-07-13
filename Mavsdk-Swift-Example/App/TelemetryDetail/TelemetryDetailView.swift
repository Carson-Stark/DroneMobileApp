//
//  TelemetryDetailView.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 17/05/21.
//

import SwiftUI

struct TelemetryDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var telemetry = TelemetryDetailViewModel()
    @ObservedObject var messageViewModel = MessageViewModel.shared
    @Binding var expanded: Bool
    
    var body: some View {
        if expanded {
            VStack(alignment: .trailing) {
                HStack {
                    ExpandViewButton(expanded: $expanded)
                    Spacer()
                }
                List(messageViewModel.allMessages) { logRecord in
                    HStack(alignment: VerticalAlignment.bottom) {
                        Text(string(from: logRecord.date))
                            .font(.system(size: 12.0, weight: .medium, design: .default))
                        Text(logRecord.message)
                            .font(.system(size: 12.0, weight: .light, design: .default))
                            .foregroundColor(logRecord.type == 0 ? .white : .blue)
                    }
                }
            }
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.9501284247)) : Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.95)))
            .cornerRadius(10.0)
            .padding(.top, 80)
            .padding(.leading, 40)
            .padding(.trailing, 10)

        } else {
            VStack {
                HStack(alignment: .top) {
                    ExpandViewButton(expanded: $expanded)
                    TelemetryInfo(value: "\(telemetry.altitude)m", title: "altitude")
                    TelemetryInfo(value: "\(telemetry.velocity)m/s", title: "velocity")
                    TelemetryInfo(value: "\(telemetry.battery)v", title: "battery")
                    TelemetryInfo(value: "\(Int(telemetry.missionProgressCurrent))/\(Int(telemetry.missionProgressTotal))", title: "mission")
                }
                Text(messageViewModel.message)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .font(.system(size: 12.0, weight: .medium, design: .default))
            }
            .frame(width: 320)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.9501284247)) : Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.95)))
            .cornerRadius(10.0)
        }
        
    }
    
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SS"
        return dateFormatter.string(from: date)
    }
}

struct TelemetryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showingMessages = true
        TelemetryDetailView(expanded: $showingMessages)
    }
}

struct TelemetryInfo: View {
    let value: String
    let title: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 15.0, weight: .semibold, design: .monospaced))
            Text(title)
                .font(.system(size: 8.0, weight: .medium, design: .default))
        }
        .padding(5)
    }
}

struct ExpandViewButton: View {
    @Binding var expanded: Bool
    
    var body: some View {
        Image(systemName: expanded ? "arrow.down.forward.and.arrow.up.backward" : "arrow.up.backward.and.arrow.down.forward")
            .font(.system(size: 16.0, weight: .semibold, design: .monospaced))
            .foregroundColor(.gray)
            .padding(5)
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            .contentShape(Rectangle())
            .onTapGesture {
                expanded.toggle()
            }
    }
}
