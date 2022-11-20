//
//  GeoCodingResult.swift
//  sixt
//
//  Created by Martin Fink on 20.11.22.
//

import Foundation

// MARK: - GeoCodingResult
struct GeoCodingResult: Codable {
//    let type: String
//    let query: [Double]
    let features: [Feature]
//    let attribution: String
}

// MARK: - Feature
struct Feature: Codable {
    let id, type: String
    let placeType: [String]
//    let relevance: Int
//    let properties: Properties
    let text, placeName: String
//    let center: [Double]
//    let geometry: Geometry
    let address: String?
//    let context: [Context]?
//    let bbox: [Double]?

    enum CodingKeys: String, CodingKey {
        case id, type
        case placeType = "place_type"
//        case relevance, properties, text
        case text
        case placeName = "place_name"
        case address
//        case center, geometry, address, context, bbox
    }
}
