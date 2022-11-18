//
//  CoatyControllerTypes.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import Foundation
import CoatySwift

enum CoatyControllerType: String, CaseIterable {
    case exampleControllerObserve = "ExampleControllerObserve"
}

extension CoatyControllerType {
    func getControllerType() -> Controller.Type {
        switch self {
        case .exampleControllerObserve:
            return ExampleControllerObserve.self
        }
    }
}
