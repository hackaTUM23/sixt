//
//  CarDetailView.swift
//  sixt
//
//  Created by Leon Friedmann on 19.11.22.
//

import SwiftUI

struct CarDetailView: View {
    
    let arrivalTime: Date = Date().addingTimeInterval(60 * 32)
    @State var isLocked = true
    @State var isLightOn = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .frame(width: 40)
                    VStack(alignment: .leading) {
                        Text("\(Date()..<arrivalTime, format: .components(style: .abbreviated, fields: [.minute]))")
                            .bold()
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Image(systemName: "ruler")
                        .frame(width: 40)
                    VStack(alignment: .leading) {
                        Text("5.8 km")
                            .bold()
                        Text("Distance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Image(systemName: "battery.25")
                        .frame(width: 40)
                    Text("15 %")
                        .bold()
                }
                HStack {
                    Button {
                        isLocked.toggle()
                    } label: {
                        Image(systemName: isLocked ? "lock" : "lock.open").frame(width: 50)
                    }
                    .tint(isLocked ? .red : .green)
                    .buttonStyle(.borderedProminent)
                    Spacer().frame(width: 20)
                    Button {
                        isLightOn.toggle()
                    } label: {
                        Image(systemName: isLightOn ? "lightbulb" : "lightbulb.slash")
                            .frame(width: 50)
                    }
                    .tint(isLightOn ? .yellow : .secondary)
                    .buttonStyle(.borderedProminent)
                    
                }
            }
            Spacer()
            VStack {
                Image("SampleCar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                VStack {
                    Text("M-UC-1337")
                        .bold()
                    Text("License plate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct CarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailView()
    }
}
