//
//  Float.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/4/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

extension Float {

    func clamp(min: Float, _ max: Float) -> Float {
        if self > max {
            return max
        } else if self < min {
            return min
        } else {
            return self
        }
    }
    
}