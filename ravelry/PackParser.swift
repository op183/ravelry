//
//  PackParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class PackParser<T>: RavelryJSONParser<T> {
    var pack: Pack?
    
    override init() {
        super.init()
    }

    override func parse(json: NSDictionary) -> PackParser<T> {
        super.parse(json)
        pack = parsePack(json as NSDictionary)
        return self
    }
    
}
