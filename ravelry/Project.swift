//
//  Project.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum Craft: Int {
    case Knitting = 2
    case Crochet = 1
}

class Project: BaseRavelryModel {
    var id: Int
    var name: String
    var craft: Craft?

    var patternId: Int
    var patternSource: PatternSource?
    var patternName: String
    var patternAuthor: Author?
    
    var firstPhoto: Mipmap
    var pattern: Pattern?
    var permalink: NSURL?
    
    var rating: String?
    var size: String?
    var photoCount: Int?

    var favoritesCount: Int?
    var commentsCount: Int?
    
    init(id: Int, patternId: Int, name: String, patternName: String, photo: Mipmap, craft: Craft? = nil) {
        self.id = id
        self.patternId = patternId
        self.name = name
        self.patternName = patternName
        self.firstPhoto = photo
        super.init()
        self.craft = craft
    }
    
    func getPattern() -> Pattern {
        return Pattern(id: self.patternId, name: self.patternName)
    }

    func getThumbnail() -> UIImage? {
        if let thumbnail = firstPhoto.getThumbnail() {
            return thumbnail.image
        }
        return nil
    }
}
