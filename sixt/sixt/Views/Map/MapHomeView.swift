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
                            openToWork ? Color.white : Color.gray
                        }.frame(width: 60, height: 30).padding(30)
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
            case .OpenToWork:
                VStack {
                    if let newChargingTask {
                    HStack(alignment: .center) {
                        NewTaskView(callBack: setNewChargingTaskNil, task: newChargingTask)
                            
                        }.frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .offset(y: self.showTask ? 0 : -400)
                            .animation(Animation.default, value: self.showTask)
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        ToggleView(isOn: $openToWork) {
                            openToWork ? Color.white : Color.gray
                        }.frame(width: 60, height: 30).padding(30)
                    }.frame(maxWidth: .infinity)
                        .background(AnimatedBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
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
            if model.userState == .OpenToWork && !self.showTask && !tasks.isEmpty {
                self.newChargingTask = tasks.last
                DispatchQueue.main.async {
                    showTask = true
                }
            }
        }
    }
    
    func setNewChargingTaskNil() {
        self.showTask = false
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
