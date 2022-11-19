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
            
            if let newChargingTask {
                VStack {
                    ZStack {
                        HStack(alignment: .center) {
                            NewTaskView(callBack: { self.showTask = false }, task: newChargingTask)
                        }.frame(maxWidth: .infinity)
                            .background(BlurView())
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
                HStack(alignment: .center) {
                    ToggleView(isOn: $openToWork) {
                        openToWork ? Color.white : Color.gray
                    }.frame(width: 60, height: 30).padding(30)
                }.frame(maxWidth: .infinity)
                    .background(ZStack {
                        if openToWork {
                            AnimatedBackground().opacity(0.8)
                        }
                        BlurView()
                    }.clipShape(RoundedRectangle(cornerRadius: 20)))
                    .padding()
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
            }
        }
        .onChange(of: model.tasks) { tasks in
            if model.userState == .OpenToWork && !self.showTask && !tasks.isEmpty {
                self.newChargingTask = tasks.last
                DispatchQueue.main.async {
                    showTask = true
                }
            }
        }
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
