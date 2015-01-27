//
//  Setting.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData

@objc class Setting: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var user_setting_id: NSManagedObject

}
