//
//  ControllerResultsDelegate.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/5/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

@objc protocol ControllerResultsDelegate {
    func didCompleteAction(results: AnyObject, action: String)
}