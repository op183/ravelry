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

    func subviewWidth(view: UIView,  _ width: CGFloat, _ relation: NSLayoutRelation = .Equal) {
        self.addConstraint(
            NSLayoutConstraint(
                item: view,
                attribute: .Width,
                relatedBy: relation,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: width
            )
        )
    }
    
    func subviewHeight(view: UIView,  _ height: CGFloat, _ relation: NSLayoutRelation = .Equal) {
        self.addConstraint(
            NSLayoutConstraint(
                item: view,
                attribute: .Height,
                relatedBy: relation,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: height
            )
        )
    }
    
    func subviewToCenterX(view: UIView, constant: Float = 0) {
        subviewToAbsolutePosition(view, constant, .CenterX)
    }
    
    func subviewToCenterY(view: UIView, constant: Float = 0) {
        subviewToAbsolutePosition(view, constant, .CenterY)
    }
    
    func subviewToCenter(view: UIView, constant: (x: Float, y: Float) = (0, 0)) {
        subviewToAbsolutePosition(view, constant.y, .CenterY)
        subviewToAbsolutePosition(view, constant.x, .CenterX)
    }
    
    func subviewToTop(view: UIView, _ top: Float) {
        subviewToAbsolutePosition(view, top, .Top)
    }
    
    func subviewToBottom(view: UIView, _ bottom: Float) {
        addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1,
                constant: CGFloat(bottom)
            )
        )
    }
    
    func subviewToLeft(view: UIView, _ left: Float) {
        subviewToAbsolutePosition(view, left, .Left)
    }
    
    func subviewToRight(view: UIView, _ right: Float) {
        subviewToAbsolutePosition(view, right, .Right)
    }
    
    
    func subviewToAbsolutePosition(view: UIView, _ cons: Float, _ attribute: NSLayoutAttribute, relation: NSLayoutRelation = .Equal) {
        addConstraint(
            NSLayoutConstraint(
                item: view,
                attribute: attribute,
                relatedBy: relation,
                toItem: self,
                attribute: attribute,
                multiplier: 1,
                constant: CGFloat(cons)
            )
        )
    }
    
    func subviewToFill(view: UIView, _ margin: CGFloat = 0) {
        addConstraints(
            [
                NSLayoutConstraint(
                    item: view,
                    attribute: .Leading,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Leading,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Trailing,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Trailing,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Top,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Bottom,
                    multiplier: 1,
                    constant: margin
                )
            ]
        )
    }
    
    func subviewRelationshipY(viewA: UIView, _ viewB: UIView, _ difference: CGFloat = 0) {
        self.addConstraint(
            NSLayoutConstraint(
                item: viewA,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: viewB,
                attribute: .Bottom,
                multiplier: 1,
                constant: difference
            )
        )
    }
    
    func subviewRelationshipX(viewA: UIView, _ viewB: UIView, _ difference: CGFloat = 0) {
        self.addConstraint(
            NSLayoutConstraint(
                item: viewA,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: viewB,
                attribute: .Left,
                multiplier: 1,
                constant: difference
            )
        )
    }
}