//
//  CoatyTaskObject.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import Foundation
import CoatySwift

struct CarDetails: Codable {
    let manufacturer: String
    let model: String
    let color: String
    let licenseNumber: String
    let batteryPercentage: Double
}

struct LatLng: Codable {
    let lat: Double
    let lng: Double
}

extension LatLng: CustomStringConvertible {
    var description: String {
        return "\(lat), \(lng)"
    }
}

class ChargingTask: CoatyObject {
    
    override class var objectType: String {
        return register(objectType: "ChargingTask", with: self)
    }
    
    // MARK: - Properties.
    
    let id: UUID
    let departure: LatLng
    let destination: LatLng
    let car: CarDetails
    let price: Double
    let estimatedDuration: Int
    
    // MARK: - Initializers.
    
    convenience init(id: UUID, departure: LatLng, destination: LatLng, car: CarDetails, price: Double, estimatedDuration: Int) {
        self.init(id: id, departure: departure, destination: destination, car: car, price: price, estimatedDuration: estimatedDuration, coreType: .CoatyObject,
                  objectType: Self.objectType,
                  objectId: .init(),
                  name: "ChargingTask")
    }
    
    init(id: UUID, departure: LatLng, destination: LatLng, car: CarDetails, price: Double, estimatedDuration: Int, coreType: CoreType, objectType: String, objectId: CoatyUUID, name: String) {
        self.id = id
        self.departure = departure
        self.destination = destination
        self.car = car
        self.price = price
        self.estimatedDuration = estimatedDuration
        
        super.init(coreType: coreType, objectType: objectType, objectId: objectId, name: name)
    }
    
    // MARK: Codable methods.
    
    enum CodingKeys: String, CodingKey {
        case id
        case departure
        case destination
        case car
        case price
        case estimatedDuration
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.departure = try container.decode(LatLng.self, forKey: .departure)
        self.destination = try container.decode(LatLng.self, forKey: .destination)
        self.car = try container.decode(CarDetails.self, forKey: .car)
        self.price = try container.decode(Double.self, forKey: .price)
        self.estimatedDuration = try container.decode(Int.self, forKey: .estimatedDuration)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.departure, forKey: .departure)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.car, forKey: .car)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.estimatedDuration, forKey: .estimatedDuration)
    }
}

class EmergencyChargingTask: ChargingTask {
    override class var objectType: String {
        return register(objectType: "EmergencyChargingTask", with: self)
    }
    
    // MARK: - Properties.
    
    let donatorCar: CarDetails
    let donatorLocation: LatLng
    
    // MARK: - Initializers.
    
    init(id: UUID, departure: LatLng, destination: LatLng, car: CarDetails, price: Double, estimatedDuration: Int, donatorCar: CarDetails, donatorLocation: LatLng) {
        self.donatorCar = donatorCar
        self.donatorLocation = donatorLocation

        super.init(id: id, departure: departure, destination: destination, car: car, price: price, estimatedDuration: estimatedDuration, coreType: .CoatyObject,
                   objectType: Self.objectType,
                   objectId: .init(),
                   name: "EmergencyChargingTask")
    }
    
    // MARK: Codable methods.
    
    enum CodingKeys: String, CodingKey {
        case donatorCar
        case donatorLocation
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.donatorCar = try container.decode(CarDetails.self, forKey: .donatorCar)
        self.donatorLocation = try container.decode(LatLng.self, forKey: .donatorLocation)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.donatorCar, forKey: .donatorCar)
        try container.encode(self.donatorLocation, forKey: .donatorLocation)
    }
}
