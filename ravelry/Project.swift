//
//  Project.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class Project: BaseRavelryModelWithPhotos {
    var craft: Craft = .Knitting

    var pattern: Pattern?
    var patternId: Int
    var patternSource: PatternSource?
    var patternName: String
    var patternAuthor: Author?
    var permalink: NSURL?
    
    var rating: String = ""
    var size: String = ""

    var favoritesCount: Int = 0
    var commentsCount: Int = 0

    var madeForUser: User?
    
    var packs = [Pack]()
    var needles = [Needle]()
    
    var notes: String = ""
    var tags = [String]()

    var status: Status = .InProgress
    var progress: Int = 0
    var started: NSDate?
    var completed: NSDate?
    
    override init() {
        self.patternId = 0
        self.patternName = ""
        super.init()
    }
    
    init(id: Int, patternId: Int, name: String, patternName: String, photo: PhotoSet, craft: Craft? = nil) {
        self.patternId = patternId
        self.patternName = patternName
        super.init(id: id, name: name, photo: photo)
        if let c = craft {
            self.craft = c
        }
    }
    
    func getPattern() -> Pattern {
        return Pattern(id: self.patternId, name: self.patternName)
    }
    
    func setStatus() {
        
    }
    
    func destroyPack() {
        
    }
}
