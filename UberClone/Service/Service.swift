//
//  Service.swift
//  UberClone
//
//  Created by wingswift on 25/09/2021.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")
let REF_TRIPS = DB_REF.child("trips")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    
    func fetchDrivers(location: CLLocation, completion: @escaping (User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { snapshot in
            
            geofire.query(at: location, withRadius: 1).observe(.keyEntered, with: { uid, location in
                self.fetchUserData(uid: uid) { user in
                    var driver = user
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
    
    
    func uploadTrip(
        pickUpLocation: CLLocationCoordinate2D,
        destinationLocation: CLLocationCoordinate2D,
        completion: @escaping(Error?, DatabaseReference) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickUpCoordinates = [pickUpLocation.latitude, pickUpLocation.longitude]
        let destinationCoordinates = [ destinationLocation.latitude, destinationLocation.longitude]
        
        let values = [
            "pickUpCoordinates": pickUpCoordinates,
            "destinationCoordinates": destinationCoordinates,
            "state": TripState.requested.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values) { error, dbRef in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    
    func observeTrips(completion: @escaping(Trip) -> Void) {
        print("ssnapshot")
        REF_TRIPS.observe(.childAdded) { snapshot in
            print("ssnapshot", snapshot)
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let passenserUid = snapshot.key
            
            let trip = Trip(passengerUid: passenserUid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    
    func acceptTrip(trip: Trip, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["driverUid": uid, "state": TripState.accepted.rawValue] as [String: Any]
        
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values) { error, dbRef in
            print("accepting trip successfully!")
            completion()
        }
        
    }
}
