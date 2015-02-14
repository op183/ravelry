//
//  CategorySplitViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/26/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategorySplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        //presentsWithGesture = true
        //delegate = self
        //preferredDisplayMode = .PrimaryOverlay
        //preferredPrimaryColumnWidthFraction = CGFloat(0.3)
    }
    
    func splitViewController(splitViewController: UISplitViewController, showViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        println("Show ViewController")
        return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        println("Show DetailViewController")
        return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        println("Collapse Secondary ViewController")
        return false
    }
    
    func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
        println("Primary ViewController for Collapsing SplitViewController")
        return nil
    }
    
    func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
        println("Primary ViewController for Expanding SplitViewController")
        return nil
    }
    
}
