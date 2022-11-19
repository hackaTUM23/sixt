//
//  MapView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct MapHomeView: View {
    @EnvironmentObject var user: User
    @State var openToWork = false
    
    var body: some View {
        ZStack {
            MapViewRepresentable()
                .ignoresSafeArea(.all)
            switch user.userState {
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
                        Button(action: { user.userState = .Working }) {
                            Text("Accept Task")
                        }.padding(20)
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal, 40)
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
                print("asdf")
                user.userState = .OpenToWork
            } else {
                user.userState = .Idle
            }
        }
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
