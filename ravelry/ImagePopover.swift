//
//  ImagePopover.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ImagePopover: UIViewController {
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var fullsizeImage: UIImageView!
    var selectedImage: Mipmap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Popover Did Load")
        fullsizeImage.image = selectedImage?.getFullsizeImage(self.view.frame.size)
    }
    
}