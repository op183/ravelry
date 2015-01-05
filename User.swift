//
//  User.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var password: String
    @NSManaged var user_setting_id: NSManagedObject

    var settings = [Setting]()
    
    class func create(attributes: [String: AnyObject]) -> User? {
        if let newUser: User = cdm!.insert("User", attributes: attributes) as? User {
            println("New User: \(newUser)")
            return newUser
        } else {
            return nil
        }
    }
}
