//
//  CarDetailView.swift
//  sixt
//
//  Created by Leon Friedmann on 19.11.22.
//

import SwiftUI

struct CarDetailView: View {
    
    let carDetails: CarDetails
    let arrivalTime: Date = Date().addingTimeInterval(60 * 32)
    let onLockCar: (_ lock: Bool) -> Void
    let onBlinkLights: () -> Void
    let onCancel: () -> Void
    @State var isLocked = true
    @State var isLightOn = false
    
    var carBatteryPercentage: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        return (formatter.string(from: NSNumber(value: carDetails.batteryPercentage)) ?? "--") + " %"
    }
    
    var body: some View {
        VStack {
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
                        Text(carBatteryPercentage)
                            .bold()
                    }
                }
                Spacer()
                VStack {
                    Image("SampleCar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        Text(carDetails.licenseNumber)
                            .bold()
                        Text("License plate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            HStack {
                Button {
                    isLocked.toggle()
                    onLockCar(isLocked)
                } label: {
                    Image(systemName: isLocked ? "lock" : "lock.open").frame(width: 50)
                }
                .tint(isLocked ? .red : .green)
                .buttonStyle(.borderedProminent)
                
                Spacer().frame(width: 20)
             
                Button {
                    isLightOn.toggle()
                    onBlinkLights()
                    
                    if isLightOn {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isLightOn = false
                            }
                        }
                    }
                } label: {
                    Image(systemName: isLightOn ? "lightbulb" : "lightbulb.slash")
                        .frame(width: 50)
                }
                .tint(isLightOn ? .yellow : .secondary)
                .buttonStyle(.borderedProminent)
                
                Spacer().frame(width: 20)
               
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 50)
                }
                .tint(.red)
                .buttonStyle(.bordered)
                
            }
        }
    }
}

struct CarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailView(
            carDetails: CarDetails(
                manufacturer: "Tesla",
                model: "Model Y",
                color: "#FF0000",
                licenseNumber: "M-UC-1234E",
                batteryPercentage: Double.random(in: 3..<10)
            ),
            onLockCar: { _ in },
            onBlinkLights: {},
            onCancel: {}
        )
    }
}
