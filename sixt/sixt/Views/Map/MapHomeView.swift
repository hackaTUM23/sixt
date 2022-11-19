//
//  MapView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct MapHomeView: View {
    @EnvironmentObject var model: Model
    
    @State var openToWork = false
    @State var showTask = false
    
    @State var newChargingTask: ChargingTask? = nil
    
    var body: some View {
        ZStack {
            MapViewRepresentable()
                .ignoresSafeArea(.all)
            switch model.userState {
            case .Idle:
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        ToggleView(isOn: $openToWork) {
                            openToWork ? Color.orange : Color.gray
                        }.frame(width: 60, height: 30).padding(30)
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal, 40)
                }
            case .OpenToWork:
                VStack {
                    HStack(alignment: .center) {
                        NewTaskView(showTask: $showTask, task: ChargingTask(id: UUID(), departure: LatLng(lat: 1.0, lng: 1.0), destination: LatLng(lat: 1.0, lng: 1.0), car: CarDetails(manufacturer: "Tesla", model: "3", color: "black", licenseNumber: "M-123", batteryPercentage: 15.0), price: 5.0, estimatedDuration: 23))
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal, 40)
                        .offset(y: showTask ? 0 : -350)
                        .animation(Animation.easeInOut(duration: 0.3), value: self.showTask)
                    Spacer()
                    HStack(alignment: .center) {
                        ToggleView(isOn: $openToWork) {
                            openToWork ? Color.orange : Color.gray
                        }.frame(width: 60, height: 30).padding(30)
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal, 40)
                }
            case .Working:
                NavigationViewRepresentable()
            }
        }.onChange(of: openToWork) { _ in
            if openToWork {
                model.userState = .OpenToWork
                showTask = true
            } else {
                model.userState = .Idle
            }
        }.onAppear {
            print("Re-render")
        }
        .onChange(of: model.tasks) { tasks in
            if model.userState == .OpenToWork && self.newChargingTask == nil && !tasks.isEmpty {
                self.newChargingTask = tasks.last
            }
        }
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
