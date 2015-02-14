//
//  Pack.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

class Pack: BaseRavelryModel {
    
    var id: Int
    
    var skeins: Int = 0
    var yards: Float = 0
    var grams: Float = 0
    
    var colorFamily: ColorFamily?
    var colorway: String = ""
    var yarn: Yarn?
    var dyeLot: String = ""
    var notes: String = ""
    var name: String = ""

    init(id: Int) {
        self.id = id
    }
    
    func getYarnWeight() -> YarnWeight? {
        if let yarn = self.yarn {
            return YarnWeight(rawValue: yarn.id)
        } else {
            return nil
        }
    }
    
    func getTotalMeters() -> Float {
        return yards * 0.9144
    }

    func yardsPerSkein() -> Float {
        return yards / Float(skeins)
    }

    func gramsPerSkein() -> Float {
        return grams / Float(skeins)
    }

    func getTotalOunces() -> Float {
        return gramsPerSkein() * 0.035274
    }

    func getQuantityDescription() -> String {
        return String(
            format: "%d skein%@s = %f yard%@s (%fm)",
            skeins,
            (skeins == 1) ? "" : "s",
            yards,
            (yards == 1) ? "" : "s",
            getTotalMeters()
        )
    }
    
}