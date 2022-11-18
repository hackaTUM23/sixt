//
//  CoatyDelegate.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import Foundation
import CoatySwift

// MARK: - Coaty Container setup methods.

class CoatyDelegate: ObservableObject {
    /// Save a reference of your container in the app delegate to
    /// make sure it stays alive during the entire lifetime of the app.
    @Published var container: Container?
    
    /// This method sets up the Coaty container necessary to run our application.
    func launchContainer() {
        // Create a configuration.
        guard let configuration = createExampleConfiguration() else {
            print("Invalid configuration! Please check your options.")
            return
        }
        
        // Register controllers and custom object types.
        let components = Components(
            controllers: CoatyControllerType.allCases.reduce(into: [String:Controller.Type]()) {
                $0[$1.rawValue] = $1.getControllerType()
            },
            objectTypes: CoatyObjectType.allTypes
        )
        
        // Allocate the container
        self.container = Container.resolve(
            components: components,
            configuration: configuration
        )
    }

    
    /// This method creates an exemplary Coaty configuration. You can use it as a basis for your
    /// application.
    private func createExampleConfiguration() -> Configuration? {
        return try? .build { config in
            // This part defines optional common options shared by all container components.
            config.common = CommonOptions()
            
            // Adjusts the logging level of CoatySwift messages, which is especially
            // helpful if you want to test or debug applications (default is .error).
            config.common?.logLevel = .debug
            
            // Configure an expressive `name` of the container's identity here.
            config.common?.agentIdentity = ["name": "Example Agent"]
            
            // You can also add extra information to your configuration in the form of a
            // [String: String] dictionary.
            config.common?.extra = ["ContainerVersion": "0.0.1"]
            
            // Define communication-related options, such as the host address of your broker
            // (default is "localhost") and the port it exposes (default is 1883). Define a
            // unqiue communication namespace for your application and make sure to immediately
            // connect with the broker, indicated by `shouldAutoStart: true`.
            let mqttClientOptions = MQTTClientOptions(
                host: UserDefaults.standard.string(forKey: "brokerHost") ?? "127.0.0.1",
                port: UInt16(UserDefaults.standard.integer(forKey: "brokerPort")),
                keepAlive: 60 * 30 // 30 mins
            )
            
            config.communication = CommunicationOptions(
                namespace: "com.fa2022.ios",
                shouldEnableCrossNamespacing: true,
                mqttClientOptions: mqttClientOptions,
                shouldAutoStart: true
            )
        }
    }
    
    /// This method shuts down the Coaty container.
    func shutdownContainer() {
        self.container?.shutdown()
    }
}

extension CoatyDelegate {
    func getContainer<T>(type: CoatyControllerType) -> T {
        assert(T.self == type.getControllerType(), "Casting to illegal type")

        return self.container?.getController(name: type.rawValue) as! T
    }
}
