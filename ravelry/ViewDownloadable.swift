//
//  ViewDownloadable.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ViewDownloadable: BaseRavelryActivity {
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "View Downloadable"
    }
    
    override func activityTitle() -> String {
        return "View Downloadable"
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: "pdf")!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        
    }
    
    override func performActivity() {
        context!.performSegueWithIdentifier("showPatternLink", sender: self)
    }
    
    override func activityDidFinish(completed: Bool) {
    }

}