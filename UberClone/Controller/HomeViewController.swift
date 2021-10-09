//
//  HomeViewController.swift
//  UberClone
//
//  Created by wingswift on 20/09/2021.
//

import UIKit
import Firebase
import MapKit

enum MenuButtonConfig {
    case menu
    case goBack
    
    init() {
        self = .menu
    }
}

class HomeViewController: UIViewController {
    let menuButton = ViewFactory.createIconButton(iconName:"line.horizontal.3")
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let locationInputActivatorView = LocationInputActivatorView()
    private let locationInputView = LocationInputView()
    private let rideActionView = RideActionView()
    private var h: NSLayoutConstraint?
    private let tableView = UITableView()
    private var placemarks = [MKPlacemark]()
    private var route: MKRoute?
    private let locationInputViewHeight: CGFloat = 200
    private let reuseIdentifier = "LocationCell"
    private let annotationIdentifier = "DriverAnnotation"
    private var menuButtonConfig = MenuButtonConfig()
    private var user: User? {
        didSet {
            self.locationInputView.user = user
            if user?.accountType == .passenger {
                fetchDrivers()
                print("I am a passenger")
                configureLocationInputActivatorView()
            } else {
                observeTrips()
            }
            
        }
    }
    
    private var trip: Trip? {
        didSet {
            guard let trip = trip else { return }
            let pickUpVC = PickUpViewController(trip: trip)
            self.present(pickUpVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        checkIfUserIsLoggedIn()
        
        locationInputActivatorView.delegate = self
        locationInputView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        rideActionView.delegate = self
        
//                signOut()
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let loginVC = LogInViewController()
            loginVC.homeVC = self
            
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
            
            print("User is not logged in...")
        } else {
            print("calling configureUI")
            configureUI()
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LogInViewController())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.shared.fetchUserData(uid: uid) { [weak self] user in
            guard let self = self else { return }
            print("geting user data")
            self.user = user
        }
    }
    
    
    func fetchDrivers() {
        guard let location = locationManager?.location else { return }
        
        Service.shared.fetchDrivers(location: location) { driver in
            guard let coordinate = driver.location?.coordinate else { return }
            
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var isDriverVisible: Bool {
                return self.mapView.annotations.contains(where: { annotation -> Bool in
                    
                    guard let driverAnnotation = annotation as? DriverAnnotation else { return false }
                    
                    if driverAnnotation.uid == driver.uid {
                        driverAnnotation.updateAnnotationPosition(with: coordinate)
                        return true
                    }
                    return false
                })
            }
            
            if !isDriverVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    func observeTrips() {
        Service.shared.observeTrips { trip in
            self.trip = trip
        }
    }
    
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }
    
    
    @objc func menuButtonTapped() {
        
        switch menuButtonConfig {
        case .menu:
            break
        case .goBack:
            
            UIView.animate(withDuration: 0.2) {
                self.locationInputActivatorView.alpha = 1
                self.menuButtonConfig = .menu
                self.animateRideActionView(shouldShow: false)
                self.menuButton.setImage(UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.removeAnnotationAndPolyline()
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
            
        }
    }
    
    
    func configureUI() {
        configureMapView()
        configureRideActionView()
        configureTableView()
        configureMenuButton()
        fetchUserData()
        enableLocationServices()
    }
    
    
    func configureMenuButton() {
        
        view.addSubview(menuButton)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    func configureLocationInputActivatorView() {
        view.addSubview(locationInputActivatorView)
        
        locationInputActivatorView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            self.locationInputActivatorView.alpha = 1.0
        }
        
        print("indicatorView calling...")
        
        NSLayoutConstraint.activate([
            locationInputActivatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            locationInputActivatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationInputActivatorView.widthAnchor.constraint(equalToConstant: view.frame.width - 64),
            locationInputActivatorView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
        
        NSLayoutConstraint.activate([
            locationInputView.topAnchor.constraint(equalTo: view.topAnchor),
            locationInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationInputView.heightAnchor.constraint(equalToConstant: locationInputViewHeight)
        ])
    }
    
    
    func configureMapView() {
        view.addSubview(mapView)
        
        mapView.frame = view.frame
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
    }
    
    
    func configureRideActionView() {
        view.addSubview(rideActionView)
        
        NSLayoutConstraint.activate([
            rideActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rideActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rideActionView.heightAnchor.constraint(equalToConstant: 300)
        ])
        self.h = NSLayoutConstraint(
            item: rideActionView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1,
            constant: 300)
        self.h?.isActive = true
    }
    
    
    func animateRideActionView(shouldShow: Bool) {
        
        if shouldShow {
            self.h?.constant = 0
        } else {
            self.h?.constant = 300
        }
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil)
        
    }
}


extension HomeViewController {
    
    func enableLocationServices() {
        
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            print("Not yet determined.")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("registered or denied.")
            break;
        case .authorizedAlways:
            print("always.")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("while in use.")
            locationManager?.requestAlwaysAuthorization()
        case .none:
            break;
        @unknown default:
            print("unknown")
            break;
        }
    }
    
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            if let error = error {
                print(error)
            }
            guard let response = response else { return }
            
            response.mapItems.forEach { item in
                results.append(item.placemark)
            }
            completion(results)
        }
    }
    
    
    func generatePolyline(toDestination destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        
        directionRequest.calculate { response, error in
            guard let response = response else { return }
            self.route = response.routes[0]
            
            guard let polyline = self.route?.polyline else { return }
            self.mapView.addOverlay(polyline)
        }
    }
    
    
    func removeAnnotationAndPolyline() {
        self.mapView.annotations.forEach { annotation in
            if let annotation = annotation as? MKPointAnnotation {
                self.mapView.removeAnnotation(annotation)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
}


extension HomeViewController: LocationInputActivatorViewDelegate {
    
    func presentLocationInputView() {
        locationInputActivatorView.alpha = 0
        configureLocationInputView()
        
    }
}


extension HomeViewController: LocationInputViewDelegate {
    
    func dismissLocationInputView() {
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.2) {
                self.locationInputActivatorView.alpha = 1
                self.menuButtonConfig = .menu
            }
        }
    }
    
    
    func executeSearch(naturalLanguage: String) {
        searchBy(naturalLanguageQuery: naturalLanguage) { placemarks in
            print(naturalLanguage)
            print(placemarks)
            self.placemarks = placemarks
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.strokeColor = .black
            lineRenderer.lineWidth = 3
            
            return lineRenderer
        }
        
        return MKOverlayRenderer()
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView( _ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        
        if indexPath.section == 1 {
            let placemark = placemarks[indexPath.row]
            cell.placemark = placemark
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : self.placemarks.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlace = placemarks[indexPath.row]
        
        generatePolyline(toDestination: MKMapItem(placemark: selectedPlace))
        
        dismissLocationView { _ in
            
            self.animateRideActionView(shouldShow: true)
            self.rideActionView.destination = selectedPlace
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlace.coordinate
            self.mapView.addAnnotation(annotation)
            
            self.menuButton.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.menuButtonConfig = .goBack
            
            let annotations = self.mapView.annotations.filter { !$0.isKind(of: DriverAnnotation.self) }
            self.mapView.zoomToFit(annotations: annotations)
        }
    }
}

extension HomeViewController: RideActionViewDelegate {
    
    func uploadTrip(_ view: RideActionView) {
        guard
            let pickUpCoordinate = locationManager?.location?.coordinate,
            let destinationCoordinate = rideActionView.destination?.coordinate
        else { return }
        
        Service.shared.uploadTrip(pickUpLocation: pickUpCoordinate, destinationLocation: destinationCoordinate) { error, dbRef in
            if let error = error {
                print(error)
                return 
            }
        }
    }
    
    
}
