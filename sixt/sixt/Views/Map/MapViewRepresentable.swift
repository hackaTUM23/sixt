//
//  MapViewRepresentable.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation
import UIKit
import SwiftUI

struct MapViewRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject var model: Model
    typealias UIViewControllerType = AdvancedViewController//MapViewController
    
//    var duckies: [DuckieBot]
    
    func makeUIViewController(context: Context) -> AdvancedViewController {
        return AdvancedViewController(model: model)
    }
    
    func updateUIViewController(_ uiViewController: AdvancedViewController, context: Context) {
//        uiViewController.duckies = duckies
//        uiViewController.destinations = destinations
//        uiViewController.chargers = chargers
    }
    
}
