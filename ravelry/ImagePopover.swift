//
//  ImagePopover.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ImagePopover: ModalSwipeNavigator {
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}