//
//  BaseRavelryModelWithPhotos.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseRavelryModelWithPhotos: BaseRavelryModel {

    var photos = [PhotoSet]()
    var photo: PhotoSet
    var name: String
    var id: Int

    override init() {
        self.photo = PhotoSet()
        self.name = ""
        self.id = 0
        super.init()
    }
    
    init(id: Int, name: String, photo: PhotoSet) {
        self.photo = photo
        self.name = name
        self.id = id
        super.init()
    }

    func getFullsizeImages() -> [UIImage] {
        var images = [UIImage]()
        
        let screenSize = UIScreen.mainScreen().bounds
        var size = CGSizeMake(screenSize.width, screenSize.height)
        for photo in photos {
            images.append(photo.getFullsizeImage(size)!)
        }
        
        return images
    }
    
    func getPhotoSetAtIndex(index: Int) -> PhotoSet? {
        return photos[index]
    }
    
    func getThumbnail() -> UIImage? {
        if let thumbnail = photo.getThumbnail() {
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

    
}
