//
//  PickUpViewController.swift
//  UberClone
//
//  Created by wingswift on 07/10/2021.
//

import UIKit
import MapKit

protocol PickUpVewControllerDelegate {
    func didAcceptTrip(_ trip: Trip)
}

class PickUpViewController: UIViewController {
    var delegate: PickUpVewControllerDelegate?
    
    let trip: Trip
    let mapView = MKMapView()
    let pickUpLabel = ViewFactory.createLabel(text: "Would you like to pick up this passenger?")
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    
    @objc func acceptTrip() {
        DriverService.shared.acceptTrip(trip: trip) {
            self.delegate?.didAcceptTrip(self.trip)
        }
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func configure() {
        view.backgroundColor = .backgroundColor
        configureCancelButton()
        configureMapView()
        configurePickUpLabel()
        configureAcceptButton()
    }
    
    
    func configureCancelButton() {
        let cancelButton = ViewFactory.createIconButton(iconName: "xmark.circle", color: UIColor.white)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        cancelButton.addTarget(nil, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    
    func configurePickUpLabel() {
        pickUpLabel.textColor = .white
        pickUpLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(pickUpLabel)
        
        NSLayoutConstraint.activate([
            pickUpLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 50),
            pickUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func configureMapView() {
        mapView.layer.cornerRadius = 270 / 2
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
      
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 128),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 270),
            mapView.widthAnchor.constraint(equalTo: mapView.heightAnchor)
        ])
        
        addAnnotationForPickUpCoordinate()
    }
    
    
    func addAnnotationForPickUpCoordinate() {
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        mapView.addAndSelectAnnotation(forCoordinate: trip.pickupCoordinates)
    }
    
    
    func configureAcceptButton() {
        let acceptButton = ViewFactory.createPrimaryButton(title: "ACCEPT TRIP")
        acceptButton.backgroundColor = .white
        acceptButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            acceptButton.topAnchor.constraint(equalTo: pickUpLabel.bottomAnchor, constant: 16),
            acceptButton.heightAnchor.constraint(equalToConstant: 44),
            acceptButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            acceptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
        
        acceptButton.addTarget(self, action: #selector(acceptTrip), for: .touchUpInside)
        
    }
}
