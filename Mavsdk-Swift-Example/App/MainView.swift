//
//  MainView.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 13/05/21.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    
    @State var isVideo: Bool = true
    @State var showingMenu = true
    @State var showingMessages = false
    @ObservedObject var mapViewCoordinator = MapViewCoordinator.shared
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topTrailing) {
                
                MapView()
                    .padding(.vertical, -100)
                    .clipped()
                    .onAppear {
                        locationManager.setupManager()
                      }

                StatusBar()
                   .frame(width: 600, height: 30, alignment: .trailing)
                   .padding(.top, 32)
                   .padding(.trailing, 45)
                
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        if !mapViewCoordinator.captureInfoCoordinates.isEmpty {
                            Image(systemName: "square.slash.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .contentShape(Rectangle())
                                .padding(.trailing, 15)
                                .foregroundColor(Color.orange.opacity(0.7))
                                .onTapGesture {
                                    mapViewCoordinator.clearPhotoLocations()
                                }
                        }
                        if !showingMessages {
                            Image(systemName: "paperplane.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .contentShape(Rectangle())
                                .padding(.trailing, 10)
                                .foregroundColor(Color.green.opacity(0.7))
                                .onTapGesture {
                                    mapViewCoordinator.centerMapOnDroneLocation()
                                }
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .contentShape(Rectangle())
                                .padding(.trailing, 45)
                                .foregroundColor(Color.white.opacity(0.7))
                                .onTapGesture {
                                    mapViewCoordinator.centerMapOnUser()
                                }
                        }
                    }
                    TelemetryDetailView(expanded: $showingMessages)
                        .padding(.trailing, 45)
                        .padding(.bottom, 15)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.all)
            
            Button(action: {
                // Toggle the boolean when the button is tapped
                showingMenu.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.9501284247))) // Customize the background color
                        .frame(width: 44, height: 44) // Adjust the size as needed
                    
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.white) // Customize the icon color
                }
            }
            .padding(.top, 32)
         
            ZStack (alignment: .bottomLeading) {
                MissionStatusView()
                    .padding(.top, 32)
                    .padding(.trailing, 50)
            }
            .frame(maxHeight: .infinity, alignment: .bottomLeading)
            
            if (showingMenu) {
                MenuView(showingMenu: $showingMenu)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
