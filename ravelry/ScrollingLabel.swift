//
//  ScrollingLabel.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ScrollingLabel: UITextView {

    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if (action == Selector("copy:") || action == Selector("selectAll:")) {
            return true;
        }
        return false
    }
    
    
}