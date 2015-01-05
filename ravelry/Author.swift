//
//  Author.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Author: BaseRavelryModel {
 
    var id: Int?
    var name: String?
    var permalink: NSURL?
    var patterns_count: Int = 0
    var favorites_count: Int = 0
    
    override init() {
        super.init()
    }

    init(id: Int, name: String?, permalink: NSURL?, patterns_count: Int, favorites_count: Int) {
        self.id = id
        self.name = name
        self.permalink = permalink
        self.patterns_count = patterns_count
        self.favorites_count = favorites_count
    }
}