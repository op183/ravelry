//
//  BaseProjectsController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/23/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseProjectsController: BaseRavelryTableViewController, AsyncLoaderDelegate, OAuthServiceResultsDelegate, MipmapLoaderDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var projects = [Project]()
    var projectsById = [Int: Project]()
    var selectedProjectId: Int?
    var selectedPattern: Pattern?
    var segueAction = "showProject"

    func imageHasLoaded(remaining: Int, _ total: Int) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let patternView = segue.destinationViewController as PatternViewController
        patternView.pattern = selectedPattern
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as ProjectCell;
        selectedProjectId = currentCell.project!.id
        mOAuthService.getPattern(currentCell.project!.patternId, delegate: self, action: "GetPattern")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as ProjectCell
        
        let project = projects[indexPath.row]
        projectsById[project.id] = project
        
        cell.project = project
        cell.titleLabel.text = project.name
        cell.thumbnailView.image = project.getThumbnail()!
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: String) {
        selectedPattern = projectsById[selectedProjectId!]!.getPattern()

        PatternParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self,
            pattern: selectedPattern!
        ).loadData(data)
    }
    
    func loadComplete(object: AnyObject, action: String) {
        self.performSegueWithIdentifier(segueAction, sender: self)
    }
    
}
