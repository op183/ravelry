//
//  BaseRavelryCollectionViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/27/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit
class BaseRavelryCollectionViewController: UICollectionViewController, UISplitViewControllerDelegate {
    
    var collapseDetailViewController: Bool = true

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        let BebasNeueBold24 = UIFont(
            name: "BebasNeueBook",
            size: 24
        )
        super.viewDidLoad()
    }
}