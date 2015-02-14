//
//  OverlayView.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/7/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class OverlayView: UIView {

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5)
        activityIndicator.center = center
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

