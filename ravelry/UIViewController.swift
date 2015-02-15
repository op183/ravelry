//
//  UIViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/6/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum BarButtonAction: String {
    case AddToProjects = "addToProjects:"
    case AddToQueue = "addToQueue:"
    case Favorite = "favorite:"
    case Unfavorite = "unfavorite:"
    case SelectPDF = "selectPDF:"
    case SelectDownload = "selectDownload:"
    case SaveProject = "saveProject:"
    case DestroyProject = "destroyProject:"

    var selector: Selector {
        return Selector(self.rawValue)
    }
}

extension UIViewController {
    
    func onResourceFailedToLoad() {
        hideOverlay()
        
    }

    func shouldAutorotate() -> Bool {
        return false
    }

    func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    func addBarButtonItem(imageName: String, action: BarButtonAction) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: imageName)!.doScaling(25, 25),
            style: .Plain,
            target: self,
            action: action.selector
        )
    }

    func addKeyboardHideObserver(action: String) {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector(action),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func addKeyboardShowObserver(action: String) {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector(action),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
    }
    
    func addBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "circle-left-arrow")!.doScaling(25, 25),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("navigateBack:")
        )
        navigationItem.setLeftBarButtonItem(backButton, animated: true)
    }
    
    @IBAction func navigateBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func showOverlay() {
        println("Showing Overlay")
        println(self)
        println(navigationController)
        navigationController?.view.addSubview(OverlayView())
    }
    
    func hideOverlay() {
        if let nav = self as? UINavigationController {
            for v in nav.view.subviews {
                println(v)
                if let overlay = v as? OverlayView {
                    println("Overlay Hidden")
                    overlay.hidden = true
                }
            }
        } else if let nav = navigationController {
            for v in nav.view.subviews {
                println(v)
                if let overlay = v as? OverlayView {
                    println("Overlay Hidden")
                    overlay.hidden = true
                }
            }
        }
    }
    
    //Constraint-Based Positioning
    func centerX(view: UIView) {
        absolutePosition(self.view, view, 0, .CenterX)
    }
    
    func centerY(view: UIView) {
        absolutePosition(self.view, view, 0, .CenterY)
    }
    
    func top(view: UIView, _ top: Float) {
        absolutePosition(self.view, view, top, .Top)
    }
    
    func bottom(view: UIView, _ bottom: Float) {
        self.view.addConstraint(
            NSLayoutConstraint(
                item: self.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1,
                constant: CGFloat(bottom)
            )
        )
    }
    
    func leftToSuperview(parent: UIView, _ view: UIView, _ left: Float) {
        absolutePosition(parent, view, left, .Left)
    }
    
    func rightToSuperview(parent: UIView, _ view: UIView, _ right: Float) {
        absolutePosition(parent, view, right, .Right)
    }
    
    func topToSuperview(parent: UIView, _ view: UIView, _ top: Float) {
        absolutePosition(parent, view, top, .Top)
    }
    
    func bottomToSuperview(parent: UIView, _ view: UIView, _ bottom: Float) {
        parent.addConstraint(
            NSLayoutConstraint(
                item: parent,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1,
                constant: CGFloat(bottom)
            )
        )
    }
    
    func left(view: UIView, _ left: Float) {
        absolutePosition(self.view, view, left, .Left)
    }
    
    func right(view: UIView, _ right: Float) {
        absolutePosition(self.view, view, right, .Right)
    }
    
    func leading(view: UIView, _ leading: Float) {
        absolutePosition(self.view, view, leading, .Leading)
    }
    
    func trailing(view: UIView, _ trailing: Float) {
        absolutePosition(self.view, view, trailing, .Trailing)
    }
    
    func height(view: UIView, _ height: Float) {
        self.view.addConstraint(
            NSLayoutConstraint(
                item: view,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: CGFloat(height)
            )
        )
    }
    
    func widthViaSuperview(parent: UIView, _ view: UIView, _ relation: NSLayoutRelation = .Equal, _ width: CGFloat = 0) {
        parent.addConstraint(
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
    
    func width(view: UIView, relation: NSLayoutRelation, width: CGFloat) {
        widthViaSuperview(self.view, view, relation, width)
    }
    
    func width(view: UIView, _ width: Float) {
        self.width(view, relation: NSLayoutRelation.Equal, width: CGFloat(width))
    }
    
    func stackY(viewA: UIView, _ viewB: UIView, _ cons: Float) {
        self.view.addConstraint(
            NSLayoutConstraint(
                item: viewA,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: viewB,
                attribute: .Bottom,
                multiplier: 1,
                constant: CGFloat(cons)
            )
        )
    }
    
    func stackX(viewA: UIView, _ viewB: UIView, _ cons: Float = 0) {
        self.view.addConstraint(
            NSLayoutConstraint(
                item: viewA,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: viewB,
                attribute: .Left,
                multiplier: 1,
                constant: CGFloat(cons)
            )
        )
    }

    
    func stackXViaSuperview(parent: UIView, _ viewA: UIView, _ viewB: UIView, _ cons: Float = 0) {
        parent.addConstraint(
            NSLayoutConstraint(
                item: viewB,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: viewA,
                attribute: .Right,
                multiplier: 1,
                constant: CGFloat(cons)
            )
        )
    }
    
    func fillSuperview(superview: UIView, _ view: UIView, _ margin: CGFloat = 0) {
        superview.addConstraints(
            [
                NSLayoutConstraint(
                    item: view,
                    attribute: .Leading,
                    relatedBy: .Equal,
                    toItem: superview,
                    attribute: .Leading,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Trailing,
                    relatedBy: .Equal,
                    toItem: superview,
                    attribute: .Trailing,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: superview,
                    attribute: .Top,
                    multiplier: 1,
                    constant: margin
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: superview,
                    attribute: .Bottom,
                    multiplier: 1,
                    constant: margin
                )
            ]
        )
    }
    
    func absolutePosition(superview: UIView, _ view: UIView, _ cons: Float, _ attribute: NSLayoutAttribute) {
        superview.addConstraint(
            NSLayoutConstraint(
                item: view,
                attribute: attribute,
                relatedBy: .Equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: CGFloat(cons)
            )
        )
    }
}