//
//  BaseRavelryActivity.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseRavelryActivity: UIActivity, PhotoSetLoaderDelegate, AsyncLoaderDelegate {

    var pattern: Pattern
    var context: UIViewController?
    
    init(pattern: Pattern) {
        self.pattern = pattern
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {

    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {

    }
}