//
//  Pattern.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Pattern: BaseRavelryModel {

    var id: Int
    var name: String
    var author: Author?
    var photo: Mipmap?
    
    var photos = [Mipmap]()
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
    var yarns = [Yarn]()
    
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
    
    init(id: Int, name: String, author: Author? = nil, photo: Mipmap? = nil, sources: [PatternSource]? = nil) {
        self.id = id
        self.name = name
        self.author = author
        self.photo = photo
        self.sources = sources
        super.init()
    }

    func getMipmapAtIndex(index: Int) -> Mipmap? {
        return photos[index]
    }
    
    func getThumbnail() -> UIImage? {
        if let thumbnail = photo!.getThumbnail() {
            return thumbnail.image
        } else {
            return nil
        }
    }
    
    func getPhotoCount() -> Int {
        return photos.count
    }
    
    func getThumbnailAtIndex(index: Int) -> UIImage? {
        if let thumbnail = photos[index].getThumbnail() {
            if let thumbnailImage = thumbnail.image {
                return thumbnail.image!
            } else {
                return nil
            }
        } else {
            return nil
        }
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

