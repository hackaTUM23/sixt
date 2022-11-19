//
//  TaskControllerPublish.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import Foundation
import CoatySwift
import RxSwift

class TaskControllerPublish: Controller {
    private var timer: Timer?
    
    override func onCommunicationManagerStarting() {
        super.onCommunicationManagerStarting()
        
        // Start RxSwift timer to publish an AdvertiseEvent every 5 seconds.
        _ = Observable
            .timer(RxTimeInterval.seconds(0),
                   period: RxTimeInterval.seconds(10),
                   scheduler: MainScheduler.instance)
            .subscribe(onNext: { (i) in
                self.advertiseExampleObject(i + 1)
            })
            .disposed(by: self.disposeBag)
    }
    
    func advertiseExampleObject(_ counter: Int) {
        let randomLatLng = { return LatLng(lat: Double.random(in: 48..<48.2), lng: Double.random(in: 11.5..<11.7)) }
        let estimatedDuration = Int.random(in: 100..<1000)
        let object: ChargingTask
        if counter.isMultiple(of: 2) {
            object = ChargingTask(
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
        } else {
            object = EmergencyChargingTask(
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
                estimatedDuration: estimatedDuration,
                donatorCar: CarDetails(
                    manufacturer: "Volkswagen",
                    model: "ID.5",
                    color: "#FFFFFF",
                    licenseNumber: "M CD 5678E",
                    batteryPercentage: Double.random(in: 80..<95)
                ),
                donatorLocation: randomLatLng()
            )
        }
        
        let event = try! AdvertiseEvent.with(object: object)
        
        self.communicationManager.publishAdvertise(event)
    }
}
