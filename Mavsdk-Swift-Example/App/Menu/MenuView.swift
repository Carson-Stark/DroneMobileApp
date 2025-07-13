//
//  MenuView.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 13/05/21.
//

import SwiftUI

struct MenuView: View {
    @State private var selectedTabIndex = 0
    @Binding var showingMenu: Bool
    @ObservedObject var mavsdk = mavsdkDrone
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                    Picker("Item", selection: $selectedTabIndex, content: {
                        Image(systemName: "xmark").tag(7)
                        Image(systemName: "arrow.up.arrow.down").tag(0)
                        Image(systemName: "antenna.radiowaves.left.and.right").tag(1)
                        Image(systemName: "play").tag(2)
                        Image(systemName: "point.topleft.down.curvedto.point.bottomright.up").tag(3)
                        //Image(systemName: "camera").tag(4)
                        //Image(systemName: "photo.on.rectangle").tag(5)
                        //Image(systemName: "gear").tag(6)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedTabIndex) { _ in
                        // Toggle the boolean when an option is selected
                        if selectedTabIndex == 7 {
                            showingMenu.toggle()
                        }
                    }
                    .padding()
                
                switch selectedTabIndex {
                case 0:
                    ConnectionView()
                        .navigationBarTitle("Connection")
                case 1:
                    TelemetryView()
                        .navigationBarTitle("Telemetry")
                case 2:
                    ActionsView()
                        .navigationBarTitle("Actions")
                case 3:
                    MissionMenuView()
                        .navigationBarTitle("Mission")
                case 4:
                    CameraView()
                        .navigationBarTitle("Camera")
                    Color.white
                case 5:
                    MediaLibraryView()
                        .navigationBarTitle("Media")
                    
                default:
                    ConnectionView()
                        .navigationBarTitle("Connection")
                //    SiteScanView()
                //        .navigationBarTitle("Site Scan")
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showingMenu = true
        MenuView(showingMenu: $showingMenu)
    }
}
