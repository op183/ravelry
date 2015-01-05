//
//  Yarn.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Yarn: BaseRavelryModel {
    
    var name: String?
    var company: String?
    
    var weightType: String?
    
    var wpi: String?
    var ply: String?
    
    var knitGauge: String?
    var minGauge: String?
    var crochetGauge: String?
    var maxGauge: String?

    
    init(
        name: String?,
        company: String?,
        weightType: String?,
        wpi: String?,
        ply: String?,
        minGauge: String?,
        maxGauge: String?,
        knitGauge: String?,
        crochetGauge: String?
    ) {
        super.init()
        self.name = name
        self.company = company
        self.weightType = weightType
        self.wpi = wpi
        self.ply = ply
        self.minGauge = minGauge
        self.maxGauge = maxGauge
        self.knitGauge = knitGauge
        self.crochetGauge = crochetGauge
    }
    
}
