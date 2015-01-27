//
//  PatternCategory.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/13/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit


class PatternCategory: BaseRavelryModel {
    var parent: PatternCategory?
    var children = [PatternCategory]()
    var permalink: NSURL?
    var name: String?
    var id: Int?
    var index: Int = 0
    var type: CategoryType?
    
    init(name: String, parent: PatternCategory?, index: Int, type: CategoryType) {
        self.name = name
        self.type = type
        self.index = index
        if let p = parent {
            self.parent = p
        }
    }
    
    init(id: Int?, name: String?, permalink: NSURL?, parent: PatternCategory?) {
        self.name = name
        self.permalink = permalink
        self.parent = parent
        super.init()
    }

    func setChild(child: PatternCategory) {
        children.append(child)
    }

    func getChildCount() -> Int {
        return children.count
    }
    
    class func getAll() -> [String:Any] {
        return [String:Any]()
    }
    
}