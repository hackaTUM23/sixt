//
//  NavigationViewRepresentable.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation
import UIKit
import SwiftUI

struct NavigationViewRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject var model: Model
    
    typealias UIViewControllerType = NavViewController
    
//    var duckies: [DuckieBot]
    
    func makeUIViewController(context: Context) -> NavViewController {
        return NavViewController(model: model)
    }
    
    func updateUIViewController(_ uiViewController: NavViewController, context: Context) {
//        uiViewController.duckies = duckies
//        uiViewController.destinations = destinations
//        uiViewController.chargers = chargers
    }
    
}
