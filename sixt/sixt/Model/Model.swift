//
//  User.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation

class Model: ObservableObject {
    static let shared: Model = Model()
    
    private init() {}
    
    @Published var userState: UserState = .Idle
    
    @Published var tasks: [ChargingTask] = []
    
    @Published var currentTask: ChargingTask? = nil
}
