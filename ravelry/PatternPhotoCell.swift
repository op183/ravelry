//
//  PatterImageCollectionCell.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class PatternPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var patternPhotoImage: UIImageView!

    var thumbnailImage: UIImage?
    var fullsizeImage: UIImage?
    var delegate: PatternViewController?
    
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
            patternPhotoImage.image = thumbnailImage
        }
    }
 
    
}