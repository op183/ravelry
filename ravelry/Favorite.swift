//
//  Favorite.swift
//  favorite
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class Favorite: BaseRavelryActivity, OAuthServiceResultsDelegate {
    /*
    override init(context: UIViewController, pattern: Pattern) {
        super.init(context: context, pattern: pattern)
    }
    */
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String {
        return "Favorite Pattern"
    }
    
    override func activityTitle() -> String {
        return "Favorite Pattern"
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: "favorite")!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
    }
    
    override func performActivity() {
        let alert = DialogueController(
            title: "Favorite \(pattern.name)?",
            message: ""
        )
        
        alert.addTextField(placeholder: "Notes")
        alert.addTextField(placeholder: "Tags")
        alert.addCancelAction()
        
        alert.addAction("Save", handler: {(action: UIAlertAction!) in
            
            var comment: String = alert.getTextFieldAtIndex(0)
            var tags: String = alert.getTextFieldAtIndex(1)
            
            ravelryUser!.addFavorite(self.pattern, comment: comment, tags: tags, delegate: self)
        })
        alert.present(context: self.context!)
    }
    
    override func activityDidFinish(completed: Bool) {
        
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {

        FavoritesParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self
        ).loadData(data)
    }

}
