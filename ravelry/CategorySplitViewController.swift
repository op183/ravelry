//
//  CategorySplitViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/26/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategorySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .PrimaryOverlay
        preferredPrimaryColumnWidthFraction = CGFloat(0.3)
    }
    
    
}
