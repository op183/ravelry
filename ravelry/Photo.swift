//
//  Photo.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/28/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

protocol PhotoDelegate {
    func photoHasLoaded(photo: Photo, action: String)
}

class Photo: BaseRavelryModel {

    var delegate: PhotoDelegate?
    var image: UIImage?
    var tag: PictureSize
    
    var name: String?
    var id: String?

    init(_ url: String, _ tag: PictureSize) {
        self.tag = tag
        super.init()
        
        Http.request(url) { (data, response, error) in
            if data != nil {
                if let image = UIImage(data: data) {
                    self.setImage(image)
                    fileCache!.putDataInCache(self.id!, name: self.name!, data: data)
                }
            } else {
                println("Image @ \(url) is Nil: \(error)")
            }
        }
    }
    
    init(image: UIImage, tag: PictureSize = .Small, delegate: PhotoDelegate) {
        self.tag = tag
        super.init()
        self.delegate = delegate
        self.setImage(image)
    }
    
    func setImage(image: UIImage) {
        self.image = image
        delay(0.1) {
            self.delegate!.photoHasLoaded(self, action: "PhotoHasLoaded")
        }
    }
    
    func setInsets(top: CGFloat, _ left: CGFloat, viewSize: CGSize? = nil) {
        var size: CGSize = image!.size
        let screenSize: CGSize = UIScreen.mainScreen().bounds.size
        var aspectRatio: CGFloat = 1.0
        var bottom: CGFloat = size.height
        var right: CGFloat = size.width

        var rawBottom = bottom
        var rawRight = right
        
        if viewSize != nil {
            bottom = viewSize!.height
            right = viewSize!.width
        }
        
        if (screenSize.height > screenSize.width) {
            aspectRatio = screenSize.width / screenSize.height;
            right *= aspectRatio
            right += left
        } else if (screenSize.width > screenSize.height) {
            aspectRatio = screenSize.height / screenSize.width;
            bottom *= aspectRatio
            bottom += top
        }

        
        
        if viewSize != nil {
            size = viewSize!
        }
        
        //println("Image Size: \(top), \(left), \(bottom), \(right)")

        var insets = UIEdgeInsetsMake(top, left, size.height, size.width)
        image!.imageWithAlignmentRectInsets(insets)
    }
}