//
//  NavigationViewController.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import UIKit
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation
import SwiftUI

class NavViewController: UIViewController {
    let model: Model
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        self.init(model: Model.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestLocationAuthorization()
        
        // Define two waypoints to travel between
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 48.249999, longitude: 11.6499974), name: "TUM CIT")
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 47.373878, longitude: 8.545094), name: "Sixt München")
        
        // Set options
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])
        routeOptions.distanceMeasurementSystem = .metric
        
        // Request a route using MapboxDirections.swift
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let self = self else { return }
                let topBanner = CustomTopBarViewController()
                let bottomBanner = CustomBottomBarViewController(model: self.model, onDismiss: {
                    self.presentedViewController?.dismiss(animated: true)
                })
                let navigationOptions = NavigationOptions(styles: [CustomDayStyle()], topBanner: topBanner, bottomBanner: bottomBanner)
                
                // Pass the first generated route to the the NavigationViewController
                let viewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: routeOptions, navigationOptions: navigationOptions)
                
                viewController.floatingButtons?.removeAll()
                viewController.showsSpeedLimits = false
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            
        }
    }
}

class CustomDayStyle: DayStyle {
    
    required init() {
        super.init()
        
        // Use a custom map style.
        mapStyleURL = URL(string: "mapbox://styles/kitesagates/clao22p31001s14phtihl44g6")!
        previewMapStyleURL = URL(string: "mapbox://styles/kitesagates/clao22p31001s14phtihl44g6")!
        
        // Specify that the style should be used during the day.
        styleType = .day
    }
    
    override func apply() {
        super.apply()
    }
}

class CustomTopBarViewController: ContainerViewController {
    private lazy var instructionsBannerTopOffsetConstraint = {
        return instructionsBannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    }()
    private lazy var centerOffset: CGFloat = calculateCenterOffset(with: view.bounds.size)
    private lazy var instructionsBannerCenterOffsetConstraint = {
        return instructionsBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
    }()
    private lazy var instructionsBannerWidthConstraint = {
        return instructionsBannerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
    }()
    
    // You can Include one of the existing Views to display route-specific info
    lazy var instructionsBannerView: InstructionsBannerView = {
        let banner = InstructionsBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        banner.layer.cornerRadius = 25
        banner.layer.opacity = 0.75
        banner.separatorView.isHidden = true
        return banner
    }()
    
    override func viewDidLoad() {
        view.addSubview(instructionsBannerView)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateConstraints()
    }
    
    private func setupConstraints() {
        instructionsBannerCenterOffsetConstraint.isActive = true
        instructionsBannerTopOffsetConstraint.isActive = true
        instructionsBannerWidthConstraint.isActive = true
    }
    
    private func updateConstraints() {
        instructionsBannerCenterOffsetConstraint.constant = centerOffset
    }
    
    // MARK: - Device rotation
    
    private func calculateCenterOffset(with size: CGSize) -> CGFloat {
        return (size.height < size.width ? -size.width / 5 : 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        centerOffset = calculateCenterOffset(with: size)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
    
    // MARK: - NavigationServiceDelegate implementation
    
    public func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        // pass updated data to sub-views which also implement `NavigationServiceDelegate`
        instructionsBannerView.updateDistance(for: progress.currentLegProgress.currentStepProgress)
    }
    
    public func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
        instructionsBannerView.update(for: instruction)
    }
    
    public func navigationService(_ service: NavigationService, didRerouteAlong route: Route, at location: CLLocation?, proactive: Bool) {
        instructionsBannerView.updateDistance(for: service.routeProgress.currentLegProgress.currentStepProgress)
    }
}

class CustomBottomBarViewController: ContainerViewController {
    
    weak var navigationViewController: NavigationViewController?
    let model: Model
    let onDismiss: () -> Void
    
    init(model: Model, onDismiss: @escaping () -> Void) {
        self.model = model
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        self.init(model: Model.shared, onDismiss: {})
    }
    
    override func loadView() {
        super.loadView()
        let hostingController = UIHostingController(rootView: NavigationBottomBarView(onDismiss: {
            self.onDismiss()
        }).environmentObject(model))
        /// Add as a child of the current view controller.
        addChild(hostingController)
        
        /// Add the SwiftUI view to the view controller view hierarchy.
        view.addSubview(hostingController.view)
        
        /// Setup the constraints to update the SwiftUI view boundaries.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        /// Notify the hosting controller that it has been moved to the current view controller.
        hostingController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    private func setupConstraints() {
        if let superview = view.superview?.superview {
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - NavigationServiceDelegate implementation
    
    func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        // Update your controls manually
        //        bannerView.progress = Float(progress.fractionTraveled)
        //        bannerView.eta = "~\(Int(round(progress.durationRemaining / 60))) min"
    }
    
}
