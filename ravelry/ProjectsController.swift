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
        segueAction = "showProject"
        self.projects = ravelryUser!.getProjects()
        (self.view as UITableView).reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        if countElements(ravelryUser!.getProjects()) != self.projects.count {
            self.projects = ravelryUser!.getProjects()
            (self.view as UITableView).reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? ProjectCell
        
        var project = projects[indexPath.row]
        
        if let craft = project.craft {
            switch craft {
                case .Knitting:
                    cell!.craftView!.image = UIImage(named: "knitting-needles")
                case .Crochet:
                    cell!.craftView!.image = UIImage(named: "crochet-hooks")
                default:
                    println("Not a listed craft!")
            }
        }
        return cell!
    }
}
