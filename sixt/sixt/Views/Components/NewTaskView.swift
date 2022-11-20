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
    
    @State var departureAddress: String? = nil
    @State var destinationAddress: String? = nil
    @State var donationCarAddress: String? = nil
    
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
                if task is EmergencyChargingTask {
                    HStack {
                        // really hacky way to ensure alignment is correct
                        Image(systemName: "arrow.right").opacity(0)
                        Text(donationCarAddress ?? "Boltzmannstr. 3").lineLimit(1)
                        
                        Spacer()
                        
                        Text(donorCarBatteryPercentage)
                        Image(systemName: "battery.75")
                        Image(systemName: "car.side")
                    }
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                        .opacity(task is EmergencyChargingTask ? 1 : 0)
                    
                    Text(departureAddress ?? "Arcisstr. 10").lineLimit(1)
                    
                    Spacer()
                    
                    Text(carBatteryPercentage)
                    Image(systemName: "battery.25")
                    Image(systemName: "car.side.and.exclamationmark")
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                    Text(destinationAddress ?? "Leipartstr. 13").lineLimit(1)
                    
                    Spacer()
                    
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
                    
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            
        }
        .padding()
        .onAppear {
            reverseGeocode(task.departure, { departureAddress = $0 })
            reverseGeocode(task.destination, { destinationAddress = $0 })
            if let emergencyTask = task as? EmergencyChargingTask {
                reverseGeocode(emergencyTask.donatorLocation, { donationCarAddress = $0 })
            }
        }
    }
    
    private func reverseGeocode(_ latLng: LatLng, _ onLoad: @escaping (_ address: String) -> Void) {
        guard let url = URL(string: "https://api.mapbox.com/geocoding/v5/mapbox.places/\(latLng.lng),\(latLng.lat).json?access_token=pk.eyJ1Ijoibmlrb2xhaW1hZGxlbmVyIiwiYSI6ImNraHRjb3R2ajA5ZGwyeXA1dGkxcWl4OHIifQ.kOZjT1J1HaZQheEttRY1Mw") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("Got error when requesting geocoding: \(error)")
            }
            
            guard let data, let geoCodingResult = try? JSONDecoder().decode(GeoCodingResult.self, from: data) else {
                return
            }
            
            guard let feature = geoCodingResult.features.first(where: { f in
                f.placeType.contains("address")
            }) else {
                return
            }
            
            onLoad("\(feature.text) \(feature.address ?? "")")
        }.resume()
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
