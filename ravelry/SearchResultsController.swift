//
//  SearchResults.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/18/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SearchResultsController: BaseResultsController {

    
    @IBOutlet var searchResults: UITableView!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var searchString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        segueAction = "selectPattern"
        searchResults.dataSource = self
        searchResults.delegate = self
        navTitle.title = "Search results for: '\(searchString)'"
    }
}