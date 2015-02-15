//
//  AddToQueue.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class AddToQueue: BaseRavelryActivity {
    
    var parser: QueuedProjectParser<NSDictionary>?
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }

    override func activityType() -> String {
        return "Add to Queue"
    }

    override func activityTitle() -> String {
        return "Add to Queue"
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
        DialogueController(title: "Add Pattern to Project Queue?").addCancelAction().addAction("OK") { (action) in
            ravelryUser!.addToQueue(self.pattern.id)
        }.present()
    }

    override func activityDidFinish(completed: Bool) {
        
    }
}
