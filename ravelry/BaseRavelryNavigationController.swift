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
            target: nil,
            action: nil
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

}