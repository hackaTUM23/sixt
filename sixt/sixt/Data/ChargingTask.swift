//
//  Task.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import Foundation

enum ChargingTask {
    case simpleTask(details: TaskDetails)
    case emergencyTask(details: TaskDetails, emergencyDetails: EmergencyTaskDetails)
}

struct TaskDetails {
    let departure: String
    let destination: String
    let car: CarDetails
    let price: Double
    let estimatedDuration: Range<Date>
}

struct EmergencyTaskDetails {
    let donatorCar: CarDetails
    let donatorLocation: String
}

struct CarDetails {
    let manufacturer: String
    let model: String
    let color: String
    let licenseNumber: String
    let batteryPercentage: Double
}
