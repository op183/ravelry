//
//  BaseResultsController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/18/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseResultsController: BaseRavelryTableViewController, AsyncLoaderDelegate, OAuthServiceResultsDelegate, MipmapLoaderDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var patterns = [Pattern]()
    var patternsById = [Int: Pattern]()
    var selectedPatternId: Int?
    var segueAction: String?
    
    func resultsHaveBeenFetched(data: NSData!, action: String) {
        PatternParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self,
            pattern: patternsById[selectedPatternId!]!
        ).loadData(data)
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        
    }
    
    func loadComplete(object: AnyObject, action: String) {
        self.performSegueWithIdentifier(segueAction!, sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let patternView = segue.destinationViewController as PatternViewController
        patternView.pattern = patternsById[selectedPatternId!]
        println("Getting Pattern \(selectedPatternId!)")
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as SearchResult;
        
        selectedPatternId = currentCell.pattern!.id
        
        mOAuthService.getPattern(selectedPatternId!, delegate: self, action: "GetPattern")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as SearchResult
        let pattern = patterns[indexPath.row]
        patternsById[pattern.id] = pattern
        
        cell.pattern = pattern
        cell.cellLabel.text = pattern.name
        cell.cellImage.image = pattern.getThumbnail()!
        return cell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patterns.count
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView {

        indicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        indicator!.center = self.view.center
        indicator!.hidesWhenStopped = true
        indicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(indicator!)

        startIndicator()
        return indicator!
    }
    
    func stopIndicator() {
        if indicator != nil {
            println("Stopping Indicator")
            indicator!.stopAnimating()
            indicator!.hidden = true
        }
    }

    func startIndicator() {
        if indicator != nil {
            indicator!.hidden = false
            indicator!.startAnimating()
        }
    }
    
    private
    var indicator: UIActivityIndicatorView?

    
}