//
//  NewTaskView.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import SwiftUI

struct NewTaskView: View {
    let task: ChargingTask
    
    //    let departure: String
    //    let destination: String
    //
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: taskDetails.price)) ?? ""
    }
    
    var carBatteryPercentage: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        return (formatter.string(from: NSNumber(value: taskDetails.car.batteryPercentage)) ?? "--") + " %"
    }
    
    var donorCarBatteryPercentage: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        if case let .emergencyTask(_, emergencyDetails) = task {
            return (formatter.string(from: NSNumber(value: emergencyDetails.donatorCar.batteryPercentage)) ?? "--") + " %"
        } else {
            return ""
        }
    }
    
    var taskDetails: TaskDetails {
        switch task {
        case .simpleTask(let details):
            return details
        case .emergencyTask(let details, _):
            return details
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("New task")
                .font(.title)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                if case let .emergencyTask(_, emergencyDetails) = task {
                    HStack {
                        // really hacky way to ensure alignment is correct
                        Image(systemName: "arrow.right").opacity(0)
                        Text(emergencyDetails.donatorLocation)
                        Image(systemName: "car.side")
                        Label(donorCarBatteryPercentage, systemImage: "battery.75")
                    }
                }
                
                HStack {
                    if case .simpleTask(_) = task {
                        Image(systemName: "arrow.right")
                            .opacity(0)
                    } else {
                        Image(systemName: "arrow.right")
                    }
                    
                    Text(taskDetails.departure)
                    Image(systemName: "car.side.and.exclamationmark")
                    
                    Label(carBatteryPercentage, systemImage: "battery.25")
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                    Text(taskDetails.destination)
                    CharginStationIcon()
                }
            }
            .padding(.bottom, 8)
            
            HStack {
                Label(totalPrice, systemImage: "eurosign")
                    .padding(.trailing)
                
                HStack {
                    Image(systemName: "clock")
                    Text(taskDetails.estimatedDuration, format: .timeDuration)
                }
            }
            .padding(.bottom)
            
            HStack {
                Button("Accept") {
                    
                }
                .buttonStyle(FilledButton())
                
                Button("Reject") {
                    
                }
                .buttonStyle(OutlineButton())
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            VStack {
                Button("Show more details") {
                    
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            
        }
        .padding()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(
            task: .simpleTask(details: .init(
                departure: "Leipartstr. 13",
                destination: "Boltzmannstr. 3",
                car: .init(
                    manufacturer: "Fiat",
                    model: "Punto",
                    color: "#ffffff",
                    licenseNumber: "AL 340 BZ",
                    batteryPercentage: 5
                ),
                price: 5.36,
                estimatedDuration: Date()..<Date().addingTimeInterval(2000)
            ))
        )
        NewTaskView(
            task: .emergencyTask(details: .init(
                departure: "Leipartstr. 13",
                destination: "Boltzmannstr. 3",
                car: .init(
                    manufacturer: "Fiat",
                    model: "Punto",
                    color: "#ffffff",
                    licenseNumber: "AL 340 BZ",
                    batteryPercentage: 5
                ),
                price: 5.36,
                estimatedDuration: Date()..<Date().addingTimeInterval(5000)
            ), emergencyDetails: EmergencyTaskDetails(
                donatorCar: .init(
                    manufacturer: "Renault",
                    model: "5 Turbo",
                    color: "#000000",
                    licenseNumber: "AL 341 BZ",
                    batteryPercentage: 73
                ),
                donatorLocation: "Arcisstr. 10"
            ))
        )
    }
}
