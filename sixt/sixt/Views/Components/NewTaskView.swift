//
//  NewTaskView.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var model: Model
    let callBack: () -> ()
    let task: ChargingTask
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: task.price)) ?? ""
    }
    
    var carBatteryPercentage: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        return (formatter.string(from: NSNumber(value: task.car.batteryPercentage)) ?? "--") + " %"
    }
    
    var donorCarBatteryPercentage: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        if let emergencyTask = task as? EmergencyChargingTask {
            return (formatter.string(from: NSNumber(value: emergencyTask.donatorCar.batteryPercentage)) ?? "--") + " %"
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("New task")
                .font(Font.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                if let emergencyTask = task as? EmergencyChargingTask {
                    HStack {
                        // really hacky way to ensure alignment is correct
                        Image(systemName: "arrow.right").opacity(0)
                        Text(emergencyTask.donatorLocation.description).lineLimit(1)
                        Image(systemName: "car.side")
                        Label(donorCarBatteryPercentage, systemImage: "battery.75")
                    }
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                        .opacity(task is EmergencyChargingTask ? 1 : 0)
                    
                    Text(task.departure.description).lineLimit(1)
                    Image(systemName: "car.side.and.exclamationmark")
                    
                    Label(carBatteryPercentage, systemImage: "battery.25")
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                    Text(task.destination.description).lineLimit(1)
                    ChargingStationIcon()
                }
            }
            .padding(.bottom, 8)
            
            HStack {
                Label(totalPrice, systemImage: "eurosign")
                    .padding(.trailing)
                
                HStack {
                    Image(systemName: "clock")
                    Text(Date()..<Date().addingTimeInterval(TimeInterval(task.estimatedDuration)), format: .timeDuration)
                }
            }
            .padding(.bottom)
            
            HStack {
                Button("Reject") {
                    model.userState = .OpenToWork
                    callBack()
                }
                .buttonStyle(OutlineButton())
                
                Button("Accept") {
                    model.userState = .Working
                    model.currentTask = task
                    callBack()
                }
                .buttonStyle(FilledButton())
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            VStack {
                Button("Show more details") {
                    model.userState = .PreviewRoute
                    model.currentTask = task
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            
        }
        .padding()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    @State static var showTask = true
   
    static var previews: some View {
        NewTaskView(
            callBack: {}, task: ChargingTask(
                id: UUID(),
                departure: LatLng(lat: 13, lng: 11),
                destination:LatLng(lat: 13, lng: 11),
                car: .init(
                    manufacturer: "Fiat",
                    model: "Punto",
                    color: "#ffffff",
                    licenseNumber: "AL 340 BZ",
                    batteryPercentage: 5
                ),
                price: 5.36,
                estimatedDuration: 2000
            )
        )
        NewTaskView(
            callBack: {}, task: EmergencyChargingTask(
                id: UUID(),
                departure: LatLng(lat: 13, lng: 11),
                destination: LatLng(lat: 13, lng: 11),
                car: .init(
                    manufacturer: "Fiat",
                    model: "Punto",
                    color: "#ffffff",
                    licenseNumber: "AL 340 BZ",
                    batteryPercentage: 5
                ),
                price: 5.36,
                estimatedDuration: 5000,
                donatorCar: .init(
                    manufacturer: "Renault",
                    model: "5 Turbo",
                    color: "#000000",
                    licenseNumber: "AL 341 BZ",
                    batteryPercentage: 73
                ),
                donatorLocation: LatLng(lat: 13, lng: 11)
            )
        )
    }
}
