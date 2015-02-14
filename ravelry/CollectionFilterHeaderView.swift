//
//  CollectionFilterHeaderView.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/28/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CollectionFilterHeaderView: UIView {

    var crochetButton: UIButton?
    var knittingButton: UIButton?

    override init() {
        super.init()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private
    func setupView() {
        backgroundColor = UIColor.whiteColor()
        var iconSize =  CGRectMake(15, 0, 35, 35)
        
        crochetButton = fitImageToButtonView("crochet-hook", frame: iconSize)
        knittingButton = fitImageToButtonView("knitting-needles", frame: iconSize)
        
        
        addSubview(crochetButton!)
        addSubview(knittingButton!)
        
        crochetButton!.setTranslatesAutoresizingMaskIntoConstraints(false)
        knittingButton!.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var margins = [
            NSLayoutConstraint(
                item: knittingButton!,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: crochetButton!,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: knittingButton!,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: crochetButton!,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: crochetButton!,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Leading,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: knittingButton!,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: crochetButton!,
                attribute: .Trailing,
                multiplier: 1,
                constant: 0
            )
        ]
        
        addConstraints(margins)
        
        formatButton(crochetButton!)
        formatButton(knittingButton!)
        
    }
    
    func formatButton(button: UIButton) {
        //button.drawBorder(2.0, color: UIColor.blackColor().CGColor, direction: .Right)
        scaleSubview(button, width: 58, height: 58)
        for l in button.layer.sublayers as [CALayer] {
            //l.frame = button.layer.bounds
        }
    }
    
    func fitImageToButtonView(imageName: String, frame: CGRect) -> UIButton {
        var button = UIButton(frame: frame)
        var image = UIImage(named: imageName)

        button.setImage(image, forState: .Normal)
        button.backgroundColor = Color.silver.uiColor
        
        button.imageView!.tintColor = Color.goldenrod.uiColor

        button.imageView!.contentMode = .ScaleAspectFit

        button.imageView!.contentMode = .ScaleAspectFill
        
        button.imageView!.autoresizingMask = .FlexibleBottomMargin
            | .FlexibleHeight
            | .FlexibleLeftMargin
            | .FlexibleRightMargin
            | .FlexibleTopMargin
            | .FlexibleWidth

        return button
    }
}
