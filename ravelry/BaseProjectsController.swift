//
//  BaseProjectsController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/23/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class BaseProjectsController: BaseRavelryTableViewController, AsyncLoaderDelegate, OAuthServiceResultsDelegate, PhotoSetLoaderDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var selectedProjectIndex: Int?
    var segueAction = "showProject"

    var totalRecords: Int {
        return ravelryUser!.totalProjects
    }
    
    var projects: [Project] {
        return ravelryUser!.getProjects()
    }

    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if projects.count == indexPath.row {
            var cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as ViewMoreCell
            cell.selected = false
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as ProjectCell
            
            let project = projects[indexPath.row]
            cell.titleLabel.text = project.name
            cell.thumbnailView.image = project.getThumbnail()!
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalRecords > projects.count {
            return projects.count + 1
        } else {
            return projects.count
        }
    }
        
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {

    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
        if let parser = object as? ProjectParser<NSDictionary> {
            self.performSegueWithIdentifier(segueAction, sender: self)
        }
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        //println("Image Has loaded: \(remaining) / \(total)")
    }


}
