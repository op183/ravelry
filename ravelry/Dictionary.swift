//
//  Dictionary.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/19/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

func +(left: [String:String], right: [String:String]) -> [String:String] {
    var d = [String: String]()
    for (k, v) in left {
        d[k] = v
    }
    
    for (k, v) in right {
        d[k] = v
    }

    return d
}