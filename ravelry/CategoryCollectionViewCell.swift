//
//  CategoryCollectionViewCell.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/26/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override init() {
        super.init()
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
}