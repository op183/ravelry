//
//  Photo.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

protocol MipmapLoaderDelegate {
    func imageHasLoaded(remaining: Int, _ total: Int)
}

class Mipmap: BaseRavelryModel, PhotoDelegate {

    var images: [String: Photo?] = [
        "s": nil,
        "m": nil,
        "square": nil,
        "thumbnail": nil,
        "shelved": nil
    ]
    
    var id: Int?
    
    var isReady: Bool = false
    var mipmapLoaderDelegate: MipmapLoaderDelegate?
    var numImages: Int = 0
    var imagesLoaded: Int = 0

    override init() {
        super.init()
    }
 
    convenience init(small: String?, medium: String?, delegate: MipmapLoaderDelegate) {
        self.init()
        self.mipmapLoaderDelegate = delegate
        if validatePhoto(small) {
            ++numImages
            self.images["s"] = Photo(small!, "s")
            if let image = self.images["s"] {
                image!.delegate = self
            }
        }
        
        if validatePhoto(medium) {
            ++numImages
            self.images["m"] = Photo(medium!, "m")
            if let image = self.images["m"] {
                image!.delegate = self
            }
        }
    }

    convenience init(small: String?, medium: String?, thumbnail: String?, delegate: MipmapLoaderDelegate) {
        self.init(small: small, medium: medium, delegate: delegate)
        if validatePhoto(thumbnail) {
            ++numImages
            self.images["thumbnail"] = Photo(thumbnail!, "thumbnail")
            if let image = self.images["thumbnail"] {
                image!.delegate = self
            }
        }
    }

    convenience init(small: String?, medium: String?, thumbnail: String?, square: String?, delegate: MipmapLoaderDelegate) {
        self.init(small: small, medium: medium, thumbnail: thumbnail, delegate: delegate)
        if validatePhoto(square) {
            ++numImages
            self.images["square"] = Photo(square!, "square")
            if let image = self.images["square"] {
                image!.delegate = self
            }
        }
    }

    convenience init(small: String?, medium: String?, thumbnail: String?, square: String?, shelved: String?, delegate: MipmapLoaderDelegate) {
        self.init(small: small, medium: medium, thumbnail: thumbnail, square: square, delegate: delegate)
        if validatePhoto(shelved) {
            ++numImages
            self.images["shelved"] = Photo(shelved!, "shelved")
            if let image = self.images["shelved"] {
                image!.delegate = self
            }
        }
    }
    
    init(named: String, delegate: MipmapLoaderDelegate) {
        super.init()
        self.mipmapLoaderDelegate = delegate
        ++numImages
        self.images["s"] = Photo(image: UIImage(named: named)!, delegate: self)
    }
    
    func getThumbnail(viewSize: CGSize? = nil) -> Photo? {
        return getImageByOrder(self.thumbnailImageOrder, viewSize: viewSize)
    }
    
    func getFullsize(viewSize: CGSize) -> Photo? {
        return getImageByOrder(self.fullsizeImageOrder, viewSize: viewSize)
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
    
    private
    
    func getImageByOrder(order: [String], viewSize: CGSize? = nil) -> Photo? {
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
    
    func validatePhoto(photo: String?) -> Bool {
        return photo != nil && photo!.match("^http(s|):\\/\\/.*\\.(jpg|png|gif|bmp|jpeg)$", "i") != nil
    }

    let fullsizeImageOrder = ["m", "shelved", "square", "s", "thumbnail"]
    let thumbnailImageOrder = ["thumbnail", "square", "s", "shelved", "m"]
    var offset: (x: Int, y: Int)? = (x: 0, y: 0)
    var sortOrder: Int = 0
    
}