//
//  MipmapCell.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class MipmapCell: UICollectionViewCell {
        
    @IBOutlet weak var imageCell: UIImageView!
    
    var thumbnailImage: UIImage?
    var fullsizeImage: UIImage?
    
    override init() {
        super.init()
        self.userInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    func setPhotoSet(photoSet: PhotoSet) {
        self.photoSet = photoSet
        setThumbnail()
    }
    
    func getFullsizeImage() -> UIImage? {
        return fullsizeImage
    }
    
    func getMipmap() -> PhotoSet? {
        return photoSet
    }
    
    private
    var photoSet: PhotoSet?
    
    func setThumbnail() {
        if photoSet != nil {
            println("Setting thumbnail image")
            thumbnailImage = photoSet!.getThumbnailImage()
            imageCell.image = thumbnailImage
        }
    }
    
}