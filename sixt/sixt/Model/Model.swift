//
//  User.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation

class Model: ObservableObject {
    @Published var userState: UserState = .Idle
}
