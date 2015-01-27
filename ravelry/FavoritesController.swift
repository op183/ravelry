//
//  FavoritesController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/18/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class FavoritesController: BaseResultsController {

    override func viewDidLoad() {
        super.viewDidLoad()
        segueAction = "showFavoritePattern"
        self.patterns = ravelryUser!.getFavorites()
        stopIndicator()
        (self.view as UITableView).reloadData()
        //mOAuthService.getFavoritesList(self, action: "GetFavorites")
    }

    override func viewDidAppear(animated: Bool) {
        if countElements(ravelryUser!.favorites) != self.patterns.count {
            self.patterns = ravelryUser!.getFavorites()
            (self.view as UITableView).reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? FavoriteCell
        
        var pattern = patterns[indexPath.row]
        patternsById[pattern.id] = pattern
        cell!.commentText.text = pattern.getComment()
        
        return cell!
        
    }

    override func resultsHaveBeenFetched(data: NSData!, action: String) {
        switch action {
            case "GetPattern":
                PatternParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self,
                    pattern: patternsById[selectedPatternId!]!
                ).loadData(data)
            case "GetFavorites":
                FavoritesParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
            default:
                println("\(action) is not an acceptable action!")
        }
        
    }
    
    override func loadComplete(object: AnyObject?, action: String) {
        switch action {
            case "PatternsLoaded":
                var parser = object as? FavoritesParser<NSDictionary>
                self.patterns = parser!.patterns
                stopIndicator()
                (self.view as UITableView).reloadData()
            case "PatternLoaded":
                self.performSegueWithIdentifier(segueAction!, sender: self)
            default:
                println("\(action) is not an acceptable action!")
        }
    }
}
