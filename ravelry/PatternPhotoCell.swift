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
    
    func setMipmap(mipmap: Mipmap) {
        self.mipmap = mipmap
        setThumbnail()
    }
    
    func getFullsizeImage() -> UIImage? {
        return fullsizeImage
    }
    
    func getMipmap() -> Mipmap? {
        return mipmap
    }
    
    private
    var mipmap: Mipmap?
    
    func setThumbnail() {
        if mipmap != nil {
            println("Setting thumbnail image")
            thumbnailImage = mipmap!.getThumbnailImage()
            patternPhotoImage.image = thumbnailImage
        }
    }
    
}