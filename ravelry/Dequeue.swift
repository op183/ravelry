//
//  Dequeue.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class Dequeue: BaseRavelryActivity {
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "Remove From Queue"
    }
    
    override func activityTitle() -> String {
        return "Remove From Queue"
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: "books")!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
    }
    
    override func performActivity() {
        DialogueController(title: "Remove Pattern from Project Queue?").addCancelAction().addAction("OK") { (action) in
            ravelryUser!.removeFromQueue(self.pattern.id)
        }.present(context: self.context!)
    }
    
    override func activityDidFinish(completed: Bool) {
        
    }
}
