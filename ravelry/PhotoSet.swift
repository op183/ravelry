//
//  PhotoSet.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

protocol PhotoSetLoaderDelegate {
    func imageHasLoaded(remaining: Int, _ total: Int)
}

enum PictureSize: String {
    case Small = "small_url"
    case Medium = "medium_url"
    case Thumbnail = "thumbnail_url"
    case Square = "square_url"
    case Shelved = "shelved_url"

    static let fullsizeImageOrder = [Medium, Small, Shelved, Square, Thumbnail]
    static let thumbnailImageOrder = [Square, Thumbnail, Shelved, Small, Medium]
    static let all = [Square, Medium, Shelved, Small, Thumbnail]
}

class PhotoSet: BaseRavelryModel, PhotoDelegate {

    var images: [PictureSize: Photo?] = [
        .Small: nil,
        .Medium: nil,
        .Square: nil,
        .Thumbnail: nil,
        .Shelved: nil
    ]
    
    var id: Int?
    
    var isReady: Bool = false
    var mipmapLoaderDelegate: PhotoSetLoaderDelegate?
    var numImages: Int = 0
    var imagesLoaded: Int = 0

    override init() {
        super.init()
    }

    init(photo: UIImage, size: PictureSize, delegate: PhotoSetLoaderDelegate) {
        super.init()
        images[size] = Photo(image: photo, tag: size, delegate: self)
    }
    
    init(photos: [PictureSize: String], delegate: PhotoSetLoaderDelegate) {
        super.init()
        self.mipmapLoaderDelegate = delegate
        for (size, photo) in photos {
            if PhotoSet.validatePhoto(photo) {
                ++numImages
                
                var matches = photo.match("\\/(\\d+?)\\/(.*$)")!
                var id = matches[0]
                var name = matches[1]
                
                if let file = fileCache!.findInCache(id, name: name) {
                    if let image = UIImage(contentsOfFile: file.absoluteString!) {
                        self.images[size] = Photo(image: image, tag: size, delegate: self)
                    } else {
                        self.images[size] = Photo(photo, size)
                        if let image = self.images[size] {
                            image!.delegate = self
                            image!.name = name
                            image!.id = id
                        }
                    }
                } else {
                    self.images[size] = Photo(photo, size)
                    if let image = self.images[size] {
                        image!.delegate = self
                        image!.name = name
                        image!.id = id
                    }
                }
                
                
                
            }
        }
    }
    
    init(named: String, delegate: PhotoSetLoaderDelegate) {
        super.init()
        self.mipmapLoaderDelegate = delegate
        ++numImages
        self.images[.Small] = Photo(image: UIImage(named: named)!, delegate: self)
    }
    
    func getThumbnail(viewSize: CGSize? = nil) -> Photo? {
        return getImageByOrder(PictureSize.thumbnailImageOrder, viewSize: viewSize)
    }
    
    func getFullsize(viewSize: CGSize) -> Photo? {
        return getImageByOrder(PictureSize.fullsizeImageOrder, viewSize: viewSize)
    }
    
    func getThumbnailImage(viewSize: CGSize? = nil) -> UIImage? {
        if let thumbnail = getThumbnail() {
            return thumbnail.image
        } else {
            return nil
        }
    }

    func getFullsizeImage(viewSize: CGSize) -> UIImage? {
        if let fullsize = getFullsize(viewSize) {
            return fullsize.image
        } else {
            return nil
        }
    }

    
    func photoHasLoaded(photo: Photo, action: String) {
        ++imagesLoaded
        if mipmapLoaderDelegate != nil {
            mipmapLoaderDelegate!.imageHasLoaded(imagesLoaded, numImages)
        }
    }

    func setSortOrder(order: Int?) {
        if order != nil {
            self.sortOrder = order!
        }
    }

    func setOffset(#x: Int?, y: Int?) {
        if x != nil && y != nil {
            self.offset = (x: x!, y: y!)
        }
    }

    class func validatePhoto(photo: String?) -> Bool {
        return photo != nil && photo!.match("^http(s|):\\/\\/.*\\.(jpg|png|gif|bmp|jpeg)$", "i") != nil
    }

    private
    
    func getImageByOrder(order: [PictureSize], viewSize: CGSize? = nil) -> Photo? {
        //println("Fetching Image")
        for size in order {
            if let image = images[size] {
                if image != nil && image!.image != nil {
                    //println("selected \(size)")
                    image!.setInsets(
                        CGFloat(offset!.y),
                        CGFloat(offset!.x),
                        viewSize: viewSize
                    )
                    return image
                }
            }
            //println("\(size) is nil")
        }
        
        return nil
    }
    
    var offset: (x: Int, y: Int)? = (x: 0, y: 0)
    var sortOrder: Int = 0
    
}