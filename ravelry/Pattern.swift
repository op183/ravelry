//
//  Pattern.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Pattern: BaseRavelryModelWithPhotos {

    var author: Author?
    
    var categories = [PatternCategory]()
    var sources: [PatternSource]?
    
    var favoritesCount: Int?
    var ratingCount: Int?

    var pdfURL: NSURL?
    var downloadURL: NSURL?
    
    var yarnWeightDescription: String?
    var yardageMax: Float?
    var yardage: String?
    var notes: String?

    var gauge: Float?
    var gaugePattern: String?
    var gaugeDescription: String?
    var gaugeDivisor: Float?
    
    
    var isReady: Bool = false
    var loaderDelegate: AsyncLoaderDelegate?
    
    var needles = [Needle]()
    var packs = [Pack]()
    
    var downloadLocation: NSURL?
    
    //User Attributes
    var comment: String?
    var tags = [String]()
    var flags = 0
    var favoriteId: Int?
    
    //flags
    let IS_FAVORITE = 2
    let IS_FREE_DOWNLOAD = 4
    let IS_RAVELRY_DOWNLOAD = 8
    
    override init() {
        super.init()
    }
    
    init(id: Int, name: String, photo: PhotoSet, author: Author? = nil, sources: [PatternSource]? = nil) {
        self.author = author
        self.sources = sources
        super.init(id: id, name: name, photo: photo)
    }
    
    convenience init(id: Int, name: String) {
        self.init(id: id, name: name, photo: PhotoSet())
    }
    
    func setTags(tagString: String) {
        
    }
    
    func getComment() -> String {
        if comment != nil {
            return comment!
        } else {
            return ""
        }
    }
    
}

