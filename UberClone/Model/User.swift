//
//  User.swift
//  UberClone
//
//  Created by wingswift on 25/09/2021.
//

import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let email: String
    let fullName: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid =  uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
