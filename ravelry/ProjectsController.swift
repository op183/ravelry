//
//  ProjectsController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ProjectsController: BaseProjectsController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == projects.count {
            if let cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as? ViewMoreCell {
                cell.selected = true
            }

            ravelryUser!.loadProjects {
                tableView.reloadData()
            }
            
        } else {
            selectedProjectIndex = indexPath.row
            var project = projects[selectedProjectIndex!]
            showOverlay()
            mOAuthService.getProject(project.id, delegate: self)
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == projects.count {
            var cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as ViewMoreCell
            cell.selected = false
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as ProjectCell
            
            let project = projects[indexPath.row]
            
            cell.titleLabel.text = project.name
            cell.thumbnailView.image = project.getThumbnail()
            
            switch project.craft {
                case .Knitting:
                    cell.craftView!.image = UIImage(named: "knitting-needles")
                case .Crochet:
                    cell.craftView!.image = UIImage(named: "crochet-hooks")
                default:
                    println("Not a listed craft!")
            }
            return cell
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var projectController = segue.destinationViewController as ProjectViewController
        hideOverlay()
        projectController.projectId = projects[selectedProjectIndex!].id
    }
    
    override func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            default:
                ProjectParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self,
                    project: projects[selectedProjectIndex!]
                ).loadData(data)

        }
    }
    
}
