//
//  sixtApp.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import SwiftUI

@main
struct sixtApp: App {

    @StateObject var delegate = CoatyDelegate()

    init() {
        UserDefaults.standard.set("finkmartin.com", forKey: "brokerHost")
        UserDefaults.standard.set(1883, forKey: "brokerPort")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    self.delegate.launchContainer()
                }
                .onReceive(
                    // properly shutdown the coaty broker
                    NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
                ) { _ in
                    self.delegate.shutdownContainer()
                }
                .environment(\.colorScheme, .dark)
        }
    }
}
