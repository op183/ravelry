//
//  AyncLoaderDelegate.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/19/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

protocol AsyncLoaderDelegate {
    func loadComplete(object: AnyObject, action: String)
}