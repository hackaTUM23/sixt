//
//  NavigationBottomBarView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct NavigationBottomBarView: View {
    @EnvironmentObject var model: Model

    let onDismiss: (() -> Void)
    
    private func doRequest(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("Got error when requesting sixt api: \(error)")
            }
            
            if let data {
                print("Successfully called sixt api: \(data)")
            }
        }.resume()
    }
    
    var body: some View {
        HStack {
            if let currentTask = model.currentTask {
                CarDetailView(
                    carDetails: currentTask.car,
                    onLockCar: { lock in
                        doRequest(url: "https://api.orange.sixt.com/v2/apps/hackatum2022/twingo/\(lock ? "lock" : "unlock")")
                    },
                    onBlinkLights: {
                        doRequest(url: "https://api.orange.sixt.com/v2/apps/hackatum2022/twingo/blink")
                    },
                    onCancel: {
                        //model.userState = .OpenToWork
                        onDismiss()
                    }
                )
            }
        }
        .padding(50)
        .frame(maxWidth: .infinity)
        .background(BlurView())
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
}

struct NavigationBottomBarView_Previews: PreviewProvider {
    init() {
        let randomLatLng = { return LatLng(lat: Double.random(in: 48..<48.2), lng: Double.random(in: 11.5..<11.7)) }
        let estimatedDuration = Int.random(in: 100..<1000)

        Model.shared.currentTask = ChargingTask(
            id: UUID(),
            departure: randomLatLng(),
            destination: randomLatLng(),
            car: CarDetails(
                manufacturer: "Fiat",
                            model: "500",
                color: "#FF0000",
                licenseNumber: "M AB 1234E",
                batteryPercentage: Double.random(in: 3..<10)
            ),
            price: Double(estimatedDuration) * 0.05,
            estimatedDuration: estimatedDuration
        )
    }
    
    static var previews: some View {
        NavigationBottomBarView(onDismiss: {})
            .preferredColorScheme(.dark)
            .environmentObject(Model.shared)
    }
}
