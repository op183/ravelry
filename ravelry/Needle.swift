//
//  Needle.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Needle: BaseRavelryModel {

    var hook: String?
    var USSize: String?
    var metricSize: Float?
    var USSteel: String?

    var knitting: Bool?
    var crochet: Bool?

    var name: String?

    init(
        hook: String?,
        USSize: String?,
        USSteel: String?,
        metricSize: Float?,
        knitting: Bool?,
        crochet: Bool?,
        name: String?
    ) {
        super.init()
        self.hook = hook
        self.USSize = USSize
        self.USSteel = USSteel
        self.metricSize = metricSize
        self.knitting = knitting
        self.crochet = crochet
        self.name = name
    }

}