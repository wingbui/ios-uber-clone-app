//
//  MKPlacemark+Ẽt.swift
//  UberClone
//
//  Created by wingswift on 30/09/2021.
//

import MapKit

extension MKPlacemark {
    var address: String? {
        get {
            guard let subThoroughfare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            return "\(subThoroughfare), \(thoroughfare), \(locality), \(adminArea)"
        }
    }
    

}
