//
//  BaseRavelryNavigationController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/31/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseRavelryNavigationController: UIViewController {

    var lastViewController: UIViewController?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        let BebasNeueBold24 = UIFont(
            name: "BebasNeueBook",
            size: 24
        )
        super.viewDidLoad()        
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: BebasNeueBold24!,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        
        let backButton = UIBarButtonItem(
            title: "<",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("navigateBack:")
        )
        
        backButton.setTitleTextAttributes(
            [
                NSFontAttributeName: BebasNeueBold24!,
                NSForegroundColorAttributeName: UIColor.blackColor()
            ],
            forState: UIControlState.Normal
        )
        
        
        navigationItem.setLeftBarButtonItem(backButton, animated: true)
        //navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func navigateBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

}