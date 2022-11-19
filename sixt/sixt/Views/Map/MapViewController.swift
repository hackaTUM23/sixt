////
////  MapViewController.swift
////  sixt
////
////  Created by Nikolai Madlener on 19.11.22.
////
//
////import UIKit
////import MapboxMaps
//
////class MapViewController: UIViewController {
////
////    internal var mapView: MapView!
////
////    override public func viewDidLoad() {
////        super.viewDidLoad()
////
////        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1Ijoibmlrb2xhaW1hZGxlbmVyIiwiYSI6ImNraHRjb3R2ajA5ZGwyeXA1dGkxcWl4OHIifQ.kOZjT1J1HaZQheEttRY1Mw")
////        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
////        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
////        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////
////        self.view.addSubview(mapView)
////    }
////}
//
//import UIKit
//import MapboxNavigation
//import MapboxCoreNavigation
//import MapboxMaps
//import SwiftUI
//
//class MapViewController: UIViewController {
//    @IBOutlet weak var theContainer: UIView!
//
//    private lazy var navigationMapView = NavigationMapView(frame: view.bounds)
//    private let toggleButton = UIButton()
//    private let passiveLocationManager = PassiveLocationManager()
//    private lazy var passiveLocationProvider = PassiveLocationProvider(locationManager: passiveLocationManager)
//
//    private var isSnappingEnabled: Bool = false {
//        didSet {
//            toggleButton.backgroundColor = isSnappingEnabled ? .blue : .darkGray
//            let locationProvider: LocationProvider = isSnappingEnabled ? passiveLocationProvider : AppleLocationProvider()
//            navigationMapView.mapView.location.overrideLocationProvider(with: locationProvider)
//            passiveLocationProvider.startUpdatingLocation()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        LocationManager.shared.requestLocationAuthorization()
//
//        setupNavigationMapView()
////        setupSnappingToggle()
//
//    }
//
//    private func setupNavigationMapView() {
//        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        navigationMapView.userLocationStyle = .puck2D()
//
//
//        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView)
//        navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
//        navigationViewportDataSource.followingMobileCamera.zoom = 17.0
//
//        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
//
//        view.addSubview(navigationMapView)
//    }
//
////    private func setupSnappingToggle() {
////
////        toggleButton.setTitle("Snap to Roads", for: .normal)
////        toggleButton.layer.cornerRadius = 5
////        toggleButton.translatesAutoresizingMaskIntoConstraints = false
////        isSnappingEnabled = false
////        toggleButton.addTarget(self, action: #selector(toggleSnapping), for: .touchUpInside)
////        view.addSubview(toggleButton)
////        toggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
////        toggleButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
////        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
////        toggleButton.sizeToFit()
////        toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
////    }
////
////    @objc private func toggleSnapping() {
////        isSnappingEnabled.toggle()
////    }
//}
