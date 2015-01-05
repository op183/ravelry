//
//  Photo.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit


protocol AsyncLoaderDelegate {
    func loadComplete(object: AnyObject)
}

class Mipmap: BaseRavelryModel, PhotoDelegate {
    var s: Photo?
    var m: Photo?
    var l: Photo?
    var xl: Photo?
    var square: Photo?
    var thumbnail: Photo?

    var isReady: Bool = false
    var loaderDelegate: AsyncLoaderDelegate?
    
    override init() {
        super.init()
    }
 
    init(small: String?, medium: String?) {
        numImages = 2
        super.init()
    }

    init(small: String?, medium: String?, square: String?) {
        numImages = 3
        super.init()
    }

    init(small: String?, medium: String?, square: String?, thumbnail: String?) {
        numImages = 4
        super.init()
        if small != nil {
            s = Photo(small!, "s")
            s!.delegate = self
        }
        
        if medium != nil {
            m = Photo(medium!, "m")
            m!.delegate = self
        }

        if square != nil {
            self.square = Photo(square!, "square")
            self.square!.delegate = self
        }

        if thumbnail != nil {
            self.thumbnail = Photo(thumbnail!, "thumbnail")
            self.thumbnail!.delegate = self
        }
    }

    func photoHasLoaded(photo: Photo) {
        //println("Photo has loaded: \(imagesLoaded) \\ \(numImages - 1)")
        ++imagesLoaded
        if imagesLoaded == numImages - 1 {
            isReady = true
            loaderDelegate?.loadComplete(self)
        }
    }
    
    private
    var numImages: Int = 0
    var imagesLoaded: Int = 0
}