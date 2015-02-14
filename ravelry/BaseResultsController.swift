//
//  BaseResultsController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/18/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseResultsController: BaseRavelryTableViewController, AsyncLoaderDelegate, OAuthServiceResultsDelegate, PhotoSetLoaderDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var patterns: [Pattern] {
        return [Pattern]()
    }

    var totalRecords: Int {
        return 0
    }
    
    var selectedPatternIndex: Int = 0
    var segueAction: String?
    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        PatternParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self,
            pattern: patterns[selectedPatternIndex]
        ).loadData(data)
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
        self.performSegueWithIdentifier(segueAction!, sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let patternView = segue.destinationViewController as PatternViewController
        hideOverlay()
        patternView.pattern = patterns[selectedPatternIndex]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if patterns.count == indexPath.row {
            var cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as ViewMoreCell
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as SearchResult
            
            let pattern = patterns[indexPath.row]
            cell.pattern = pattern
            cell.cellLabel.text = pattern.name
            cell.cellImage.image = pattern.getThumbnail()!
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalRecords > patterns.count {
            return patterns.count + 1
        } else {
            return patterns.count
        }
    }
}