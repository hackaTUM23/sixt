//
//  ExampleObject.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation
import CoatySwift

final class ExampleCoatyObject: CoatyObject {
    
    // MARK: - Class registration.
    
    override class var objectType: String {
        return register(objectType: "Example", with: self)
    }
    
    // MARK: - Properties.
    
    let exampleId: String
    
    
    // MARK: - Initializers.
    
    init(exampleId: String) {
        self.exampleId = exampleId
        
        super.init(coreType: .CoatyObject,
                   objectType: Self.objectType,
                   objectId: .init(),
                   name: "Example")
    }
    
    // MARK: Codable methods.
    
    enum CodingKeys: String, CodingKey {
        case exampleId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exampleId = try container.decode(String.self, forKey: .exampleId)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.exampleId, forKey: .exampleId)
    }
}
