//
//  QueueController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/23/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class QueueController: BaseProjectsController {
    
    var selectedPattern: Pattern?

    override var totalRecords: Int {
        return ravelryUser!.totalQueuedProjects
    }
    
    override var projects: [Project] {
        return ravelryUser!.getQueue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        segueAction = "showPattern"
        (self.view as UITableView).reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        (self.view as UITableView).reloadData()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == projects.count {
            if let cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as? ViewMoreCell {
                cell.selected = true
            }

            ravelryUser!.loadQueue {
                tableView.reloadData()
            }
            
        } else {
            selectedProjectIndex = indexPath.row
            showOverlay()
            mOAuthService.getPattern(projects[selectedProjectIndex!].patternId, delegate: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let patternView = segue.destinationViewController as PatternViewController
        hideOverlay()
        patternView.pattern = selectedPattern
    }
    
    override func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            default:
                selectedPattern = projects[selectedProjectIndex!].getPattern()
                
                PatternParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self,
                    pattern: selectedPattern!
                ).loadData(data)

        }
    }
    
}
