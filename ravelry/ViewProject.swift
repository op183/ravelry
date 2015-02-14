//
//  ViewProject.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ViewProject: BaseRavelryActivity {
    
    var project: Project?
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "View Project"
    }
    
    override func activityTitle() -> String {
        return "View Project"
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: "scissors")!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {

    }
    
    override func performActivity() {
        if let project = ravelryUser!.getProjectByPatternId(pattern.id) {
            self.project = project
            if let vc = context as? PatternViewController {
                vc.segueAction = "showProject"
                vc.performSegueWithIdentifier("showProject", sender: self)
            }
        }
    }
    
    override func activityDidFinish(completed: Bool) {
        
    }
}