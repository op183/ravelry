//
//  AddToProjects.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class AddToProjects: BaseRavelryActivity, OAuthServiceResultsDelegate {

    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "Add to Projects"
    }
    
    override func activityTitle() -> String {
        return "Add to Projects"
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
        DialogueController(title: "Add Pattern to Projects?").addCancelAction().addAction("OK") { (action) in
            ravelryUser!.createProject(self.pattern)
        }.present(context: self.context!)
    }
    
    override func activityDidFinish(completed: Bool) {
        
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        ProjectsParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self
        ).loadData(data)
    }

}
