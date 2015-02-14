//
//  BaseRavelryNavigationController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/31/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseRavelryNavigationController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        //navigationItem.backBarButtonItem = backButton
    }
}