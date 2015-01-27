//
//  BaseRavelryTableViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/1/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseRavelryTableViewController: UITableViewController {
    
    var lastViewController: UIViewController?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let BebasNeueBold24 = UIFont(
            name: "BebasNeueBook",
            size: 24
        )
        
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