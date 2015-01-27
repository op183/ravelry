//
//  QueueController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/23/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class QueueController: BaseProjectsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projects = ravelryUser!.getQueue()
        (self.view as UITableView).reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        let queue = ravelryUser!.getQueue()
        if countElements(queue) != self.projects.count {
            self.projects = queue
            (self.view as UITableView).reloadData()
        }
    }
    

}
