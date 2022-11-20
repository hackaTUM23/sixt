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
    @State var accepted = false
    @State var showTask = false
    @State var newChargingTask: ChargingTask? = nil
    
    var body: some View {
        ZStack {
            MapViewRepresentable()
                .ignoresSafeArea(.all)
            
            if let newChargingTask {
                VStack {
                    ZStack {
                        HStack(alignment: .center) {
                            NewTaskView(callBack: {
                                self.showTask = false;
                                self.accepted = true
                            }, task: newChargingTask)
                        }.frame(maxWidth: .infinity)
                            .background(BlurView(style: .light))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .offset(y: self.showTask ? 0 : -400)
                            .animation(Animation.default, value: self.showTask)
                    }
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
//                HStack(alignment: .center) {
//                    VStack {
//                        Text("Open to work")
//                            .font(.headline)
//                            .preferredColorScheme(.dark)
//                        ToggleView(isOn: $openToWork) {
//                            openToWork ? Color.white : Color.gray
//                        }.frame(width: 60, height: 30)
//                    }.padding(30)
//                }.frame(maxWidth: .infinity)
//                    .background(ZStack {
//                        if openToWork {
//                            AnimatedBackground()
//                        } else {
//                            BlurView(style: .dark)
//                        }
//                    }.clipShape(RoundedRectangle(cornerRadius: 20)))
//                    .padding()
                HomeButtonview(isStarted: $openToWork, accepted: $accepted)
            }
            
//            if case .Working = model.userState {
//                BlurView()
//                    .frame(width: 100, height: 100)
//                ProgressView()
//                NavigationViewRepresentable()
//            }
        }.onChange(of: openToWork) { _ in
            if openToWork {
                model.userState = .OpenToWork
            } else {
                model.userState = .Idle
                showTask = false
            }
        }
        .onChange(of: model.tasks) { tasks in
            if model.userState == .OpenToWork && !self.showTask && !tasks.isEmpty {
                self.newChargingTask = tasks.last
                DispatchQueue.main.async {
                    showTask = true
                    accepted = false
                }
            }
        }
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
            .environmentObject(Model.shared)
    }
}
