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
    typealias UIViewControllerType = MapViewController
    
//    var duckies: [DuckieBot]
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
//        uiViewController.duckies = duckies
//        uiViewController.destinations = destinations
//        uiViewController.chargers = chargers
    }
    
}
