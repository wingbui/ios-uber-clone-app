//
//  LocationHandler.swift
//  UberClone
//
//  Created by wingswift on 26/09/2021.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
   
    static let shared = LocationHandler()
    
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager?.authorizationStatus == .authorizedWhenInUse {
            locationManager?.requestAlwaysAuthorization()
        }
    }
}
