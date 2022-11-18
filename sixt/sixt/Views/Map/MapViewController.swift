//
//  MapViewController.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import Foundation
import MapKit
import UIKit
import SwiftUI
import CoreLocation

class MapViewController: UIViewController {
    private var mapView: MKMapView!
    
    private func setupInitialLocation() {
        // TODO: Apply math to set the region to the correct zoom, restrict the region to 16 tiles, we create this tiles using the tool
        // TODO: restrict the scrolling outside of the set region; https://stackoverflow.com/questions/5680896/ios-how-to-limit-the-mapview-to-a-specific-region
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(48.14828),
                                              longitude: CLLocationDegrees(11.56996))
        
        let region = self.mapView.regionThatFits(MKCoordinateRegion(center: location,
                                                                    latitudinalMeters: CLLocationDistance(exactly: 30000)!,
                                                                    longitudinalMeters: CLLocationDistance(exactly: 25000)!))
        
//        self.mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 45000,
//                                                                 maxCenterCoordinateDistance: 70000)
        
        self.mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.showsPointsOfInterest = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = MKMapView()
        self.view = self.mapView
        
        
        // Hard code the initial coordinates
        setupInitialLocation()
    }
}
