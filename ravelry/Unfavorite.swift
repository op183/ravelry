//
//  Unfavorite.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class Unfavorite: BaseRavelryActivity, OAuthServiceResultsDelegate {

    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "Unfavorite"
    }
    
    override func activityTitle() -> String {
        return "Unfavorite"
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: "favorites")!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
    }
    
    override func performActivity() {
        ravelryUser!.destroyFavorite(pattern.id, delegate: self)
    }
    
    override func activityDidFinish(completed: Bool) {
        
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
    }

}
