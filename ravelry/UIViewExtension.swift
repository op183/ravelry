//
//  UIViewExtension.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/7/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum RelativeDirection:Int {
    case Left = 1
    case Right = 2
    case Top = 4
    case Bottom = 8
}

extension UIView {

    
    func drawBorder(size: CGFloat, color: CGColor, direction: RelativeDirection) {
        drawScaledBorder(size, width: frame.size.width, height: frame.size.height, color: color, direction: direction)
    }
    
    func drawScaledBorder(size: CGFloat, width: CGFloat, height: CGFloat, color: CGColor, direction: RelativeDirection) {
        var border = CALayer()
        switch direction {
        case .Left:
                border.frame = CGRect(
                    x: 0,
                    y: height,
                    width: size,
                    height: height
                )

        case .Right:
                border.frame = CGRect(
                    x: width,
                    y: 0,
                    width: size,
                    height: height
                )

        case .Top:
                border.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: width,
                    height: size
                )

        case .Bottom:
                border.frame = CGRect(
                    x: 0,
                    y: height,
                    width: width,
                    height: size
                )
        }
        
        border.borderWidth = size
        border.borderColor = color
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func scaleSubview(button: UIButton, width: CGFloat, height: CGFloat) {
        self.addConstraint(
            NSLayoutConstraint(
                item: button,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: width
            )
        )
        
        self.addConstraint(
            NSLayoutConstraint(
                item: button,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: height
            )
        )
        
    }

}