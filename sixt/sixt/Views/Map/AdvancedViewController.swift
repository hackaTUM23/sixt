//
//  AdvancedViewController.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps
import Combine


class AdvancedViewController: UIViewController, NavigationMapViewDelegate, NavigationViewControllerDelegate {
    
    let model: Model
    
    var requestCancellable: AnyCancellable?
    var navHasStarted = false
    
    init(model: Model) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.requestCancellable = Model.shared.objectWillChange.sink(receiveValue: {
            switch Model.shared.userState {
            case .Working:
                if let currentTask = Model.shared.currentTask, !self.navHasStarted {
                    let emergencyTask = currentTask as? EmergencyChargingTask
                    let car2Location: CLLocationCoordinate2D?
                    if let emergencyTask {
                        car2Location = CLLocationCoordinate2D(latitude: emergencyTask.donatorLocation.lat, longitude: emergencyTask.donatorLocation.lng)
                    } else {
                        car2Location = nil
                    }
        
                    self.requestRoute(carLocation: CLLocationCoordinate2D(latitude: currentTask.departure.lat, longitude: currentTask.departure.lng),
                                      car2Location: car2Location,
                                      destination: CLLocationCoordinate2D(latitude: currentTask.destination.lat, longitude: currentTask.destination.lng))
                    self.startNavigation()
                }
            case .PreviewRoute:
                if let currentTask = Model.shared.currentTask, !self.navHasStarted {
                    let emergencyTask = currentTask as? EmergencyChargingTask
                    let car2Location: CLLocationCoordinate2D?
                    if let emergencyTask {
                        car2Location = CLLocationCoordinate2D(latitude: emergencyTask.departure.lat, longitude: emergencyTask.departure.lng)
                    } else {
                        car2Location = nil
                    }
        
                    self.requestRoute(carLocation: CLLocationCoordinate2D(latitude: currentTask.departure.lat, longitude: currentTask.departure.lng),
                                      car2Location: car2Location,
                                      destination: CLLocationCoordinate2D(latitude: currentTask.destination.lat, longitude: currentTask.destination.lng))
                }
            case .OpenToWork:
                self.navigationMapView.removeRoutes()
                self.navigationMapView.removeWaypoints()
                self.navigationMapView.removeArrow()
            default:
                print("")
            }
        })
        
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(model: Model.shared)
    }
    
    var navigationMapView: NavigationMapView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview()
            }
            
            navigationMapView.translatesAutoresizingMaskIntoConstraints = false
            
            view.insertSubview(navigationMapView, at: 0)
            
            NSLayoutConstraint.activate([
                navigationMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navigationMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navigationMapView.topAnchor.constraint(equalTo: view.topAnchor),
                navigationMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    var navigationRouteOptions: NavigationRouteOptions!
    var currentRouteIndex = 0 {
        didSet {
            showCurrentRoute()
        }
    }
    var currentRoute: Route? {
        return routes?[currentRouteIndex]
    }
    
    var routes: [Route]? {
        return routeResponse?.routes
    }
    
    var routeResponse: RouteResponse? {
        didSet {
            guard currentRoute != nil else {
                navigationMapView.removeRoutes()
                return
            }
            currentRouteIndex = 0
        }
    }
    
    func showCurrentRoute() {
        guard let currentRoute = currentRoute else { return }
        
        var routes = [currentRoute]
        routes.append(contentsOf: self.routes!.filter {
            $0 != currentRoute
        })
        navigationMapView.showcase(routes)
    }
    
    func showNoRoute() {
        var routes: [Route] = []
        navigationMapView.showcase(routes)
    }
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMapView = NavigationMapView(frame: view.bounds)
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationMapView.delegate = self
        navigationMapView.userLocationStyle = .puck2D()
        
        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
        navigationViewportDataSource.followingMobileCamera.zoom = 13.0
        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        
        view.addSubview(navigationMapView)
        view.setNeedsLayout()
    }
    
    func startNavigation() {
        guard let routeResponse = routeResponse, let navigationRouteOptions = navigationRouteOptions else { return }
        navHasStarted = true
        // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
        let navigationService = MapboxNavigationService(routeResponse: routeResponse,
                                                        routeIndex: currentRouteIndex,
                                                        routeOptions: navigationRouteOptions,
                                                        customRoutingProvider: NavigationSettings.shared.directions,
                                                        credentials: NavigationSettings.shared.directions.credentials,
                                                        simulating: .onPoorGPS)
        let topBanner = CustomTopBarViewController()
        
        
        let navigationOptions = NavigationOptions(navigationService: navigationService,
                                                  topBanner: topBanner,
                                                  // Replace default `NavigationMapView` instance with instance that is used in preview mode.
                                                  navigationMapView: navigationMapView)
        
        
        
        //        let navigationOptions = NavigationOptions(styles: [CustomDayStyle()], topBanner: topBanner, bottomBanner: bottomBanner)
        
        // Pass the first generated route to the the NavigationViewController
        let navigationViewController = NavigationViewController(for: routeResponse, routeIndex: currentRouteIndex, routeOptions: navigationRouteOptions, navigationOptions: navigationOptions)
        
        let bottomBanner = CustomBottomBarViewController(model: self.model, onDismiss: {
            //            self.presentedViewController?.dismiss(animated: true)
            self.navigationViewControllerDidDismiss(navigationViewController, byCanceling: true)
        })
        
        navigationViewController.navigationOptions?.bottomBanner = bottomBanner
        
        navigationViewController.floatingButtons?.removeAll()
        navigationViewController.showsSpeedLimits = false
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true, completion: nil)
        navigationViewController.delegate = self
        
        
        
        //        let navigationViewController = NavigationViewController(for: routeResponse,
        //                                                                routeIndex: currentRouteIndex,
        //                                                                routeOptions: navigationRouteOptions,
        //                                                                navigationOptions: navigationOptions)
        //        navigationViewController.delegate = self
        //        navigationViewController.modalPresentationStyle = .fullScreen
        //
        
        
        if let latestValidLocation = navigationMapView.mapView.location.latestLocation?.location {
            navigationViewController.navigationMapView?.moveUserLocation(to: latestValidLocation)
        }
        
        // Hide top and bottom container views before animating their presentation.
        //        navigationViewController.navigationView.bottomBannerContainerView.hide(animated: false)
        //        navigationViewController.navigationView.topBannerContainerView.hide(animated: false)
        
        // Hide `WayNameView`, `FloatingStackView` and `SpeedLimitView` to smoothly present them.
        navigationViewController.navigationView.wayNameView.alpha = 0.0
        navigationViewController.navigationView.floatingStackView.alpha = 0.0
        navigationViewController.navigationView.speedLimitView.alpha = 0.0
        
        //        present(navigationViewController, animated: false) {
        //            // Animate top and bottom banner views presentation.
        //            let duration = 1.0
        //            navigationViewController.navigationView.bottomBannerContainerView.show(duration: duration,
        //                                                                                   animations: {
        //                navigationViewController.navigationView.wayNameView.alpha = 1.0
        //                navigationViewController.navigationView.floatingStackView.alpha = 1.0
        //                navigationViewController.navigationView.speedLimitView.alpha = 1.0
        //            })
        //            navigationViewController.navigationView.topBannerContainerView.show(duration: duration)
        //
    }
    
    func requestRoute(carLocation: CLLocationCoordinate2D, car2Location: CLLocationCoordinate2D?, destination: CLLocationCoordinate2D) {
        guard let userLocation = navigationMapView.mapView.location.latestLocation else { return }
        
        let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude)
        
        let userWaypoint = Waypoint(location: location,
                                    heading: userLocation.heading,
                                    name: "user")
        
        let destinationWaypoint = Waypoint(coordinate: destination)
        let carLocationWaypoint = Waypoint(coordinate: carLocation)
        var wayPoints: [Waypoint] = [userWaypoint, carLocationWaypoint, destinationWaypoint]
        if let car2Location {
            wayPoints.insert(Waypoint(coordinate: car2Location), at: 1)
        }
        let navigationRouteOptions = NavigationRouteOptions(waypoints: wayPoints)
        
        Directions.shared.calculate(navigationRouteOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let self = self else { return }
                
                self.navigationRouteOptions = navigationRouteOptions
                self.routeResponse = response
                if let routes = self.routes,
                   let currentRoute = self.currentRoute {
                    
                    let navigationViewportDataSource = NavigationViewportDataSource(self.navigationMapView.mapView, viewportDataSourceType: .raw)
                    navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = true
              
                    let camOp = CameraOptions(padding: UIEdgeInsets(
                        top: 400,
                        left: 40,
                        bottom: 200,
                        right: 40.0
                    ))
                    
                    self.navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
                    
//                    self.navigationMapView.show(routes)
                    self.navigationMapView.showWaypoints(on: currentRoute)
        
                    if let routes = self.routes {
                        let cameraOptions = CameraOptions(bearing: 0.0, pitch: 0.0)
                        self.navigationMapView.showcase(routes,
                                                        routesPresentationStyle: .all(shouldFit: true, cameraOptions: camOp),
                                                        animated: true,
                                                        duration: 1.0)
                    }
                }
            }
        }
    }
    
    // Delegate method called when the user selects a route
    func navigationMapView(_ mapView: NavigationMapView, didSelect route: Route) {
        self.currentRouteIndex = self.routes?.firstIndex(of: route) ?? 0
    }
    
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        let duration = 1.0
        navigationViewController.navigationView.topBannerContainerView.hide(duration: duration)
        navigationViewController.navigationView.bottomBannerContainerView.hide(duration: duration,
                                                                               animations: {
            navigationViewController.navigationView.wayNameView.alpha = 0.0
            navigationViewController.navigationView.floatingStackView.alpha = 0.0
            navigationViewController.navigationView.speedLimitView.alpha = 0.0
        },
                                                                               completion: { [weak self] _ in
            navigationViewController.navigationService.stop()
            navigationViewController.dismiss(animated: false) {
                guard let self = self else { return }
                
                // Show previously hidden button that allows to start active navigation.
                
                
                
                // Since `NavigationViewController` assigns `NavigationMapView`'s delegate to itself,
                // delegate should be re-assigned back to `NavigationMapView` that is used in preview mode.
                self.navigationMapView.delegate = self
                
                // Replace `NavigationMapView` instance with instance that was used in active navigation.
                self.navigationMapView = navigationViewController.navigationMapView
                
                
                
                // Since `NavigationViewController` uses `UserPuckCourseView` as a default style
                // of the user location indicator - revert to back to default look in preview mode.
                self.navigationMapView.userLocationStyle = .puck2D()
                self.model.userState = .OpenToWork
                self.model.currentTask = nil
                self.navHasStarted = false
                
                //TODO: clear routes array
                
                //Showcase originally requested routes.
                //                                if let routes = self.routes {
                //                                    let cameraOptions = CameraOptions(bearing: 0.0, pitch: 0.0)
                //                                    self.navigationMapView.showcase(routes,
                //                                                                    routesPresentationStyle: .all(shouldFit: true, cameraOptions: cameraOptions),
                //                                                                    animated: true,
                //                                                                    duration: duration)
                //                                }
                self.showNoRoute()
            }
        })
    }
}

