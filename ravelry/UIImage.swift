//
//  UIImage.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

extension UIImage {

    func doScaling(w: CGFloat, _ h: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(w, h))
        drawInRect(CGRectMake(0, 0, w, h))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    
}