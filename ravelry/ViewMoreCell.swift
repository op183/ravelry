//
//  ViewMoreCell.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ViewMoreCell: UITableViewCell {

    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var loadingMore: UIActivityIndicatorView!
 
    override var selected: Bool {
        didSet(isSelected) {
            if !isSelected {
                loadingMore.hidden = true
                viewMoreButton.hidden = false
                userInteractionEnabled = true
            } else {
                loadingMore.hidden = false
                viewMoreButton.hidden = true
                userInteractionEnabled = false
            }
        }
    }
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}