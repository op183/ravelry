//
//  Pattern.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Pattern: BaseRavelryModel, AsyncLoaderDelegate {
    
    var name: String
    var author: Author
    var photo: Mipmap
    var sources: [PatternSource]
    var id: Int?
    
    var yarnWeight: String?
    var yardageMax: Float?
    var yardage: String?
    var gaugePattern: String?
    var notes: String?
    var gauge: Float?
    var gaugeDivisor: Float?
    
    var downloadURL: NSURL?
    
    var isReady: Bool = false
    var loaderDelegate: AsyncLoaderDelegate?
    
    var needles = [Needle]()
    var yarns = [Yarn]()
    
    init(id: Int, name: String, author: Author, photo: Mipmap, sources: [PatternSource]) {
        self.id = id
        self.name = name
        self.author = author
        self.photo = photo
        self.sources = sources
        super.init()
        self.photo.loaderDelegate = self
    }

    func getThumbnail() -> UIImage? {
        if photo.thumbnail!.image != nil {
            return photo.thumbnail!.image!
        } else if photo.s!.image != nil {
            return photo.s!.image!
        }
        return nil
    }
    
    func loadComplete(object: AnyObject) {
        //println("Pattern \(self.name) has finished loading...")
        if loaderDelegate != nil {
            loaderDelegate!.loadComplete(object)
        }
    }
}

