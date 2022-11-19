//
//  CoatyControllerTypes.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import Foundation
import CoatySwift

enum CoatyControllerType: String, CaseIterable {
    case taskControllerPublish = "TaskControllerPublish"
    case taskControllerObserve = "TaskControllerObserve"
}

extension CoatyControllerType {
    func getControllerType() -> Controller.Type {
        switch self {
        case .taskControllerPublish:
            return TaskControllerPublish.self
        case .taskControllerObserve:
            return TaskControllerObserve.self
        }
    }
}
