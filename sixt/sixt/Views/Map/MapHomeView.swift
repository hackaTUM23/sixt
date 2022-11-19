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
                    if let newChargingTask {
                        HStack(alignment: .center) {
                            Button(action: { model.userState = .Working }) {
                                Text("Accept Task \(newChargingTask.id)")
                            }.padding(20)
                            Button("Cancel") {
                                self.newChargingTask = nil
                            }
                        }.frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .padding(.horizontal, 40)
                    }
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
