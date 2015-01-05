//
//  SearchResults.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/18/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SearchResultsController: BaseRavelryNavigationController, UITableViewDelegate, UITableViewDataSource, AsyncLoaderDelegate {
    
    let segueAction = "selectPattern"
    
    var patterns = [Pattern]()
    var patternsById = [Int: Pattern]()
    var searchString = ""
    var parser: PatternParser<NSDictionary>?
    var selectedPatternId: Int?
    
    @IBOutlet weak var navTitle: UINavigationItem!

    @IBAction func showMoreResults(sender: UIButton) {
        
    }
    
    @IBAction func searchButton(sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet weak var searchResults: UITableView!

    
    func loadComplete(object: AnyObject) {
        self.performSegueWithIdentifier(segueAction, sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let patternView = segue.destinationViewController as PatternViewController
        patternView.pattern = patternsById[selectedPatternId!]
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchResults.dataSource = self
        searchResults.delegate = self

        navTitle.title = "Search results for: '\(searchString)'"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patterns.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as SearchResult;
        
        selectedPatternId = currentCell.pattern!.id!
        
        println("Select Pattern \(patternsById[selectedPatternId!]!.id)")
        
        var url = NSURL(
            scheme: "https",
            host: "api.ravelry.com",
            path: "/patterns/\(selectedPatternId!).json"
        )
        
        PatternParser<NSDictionary>(
            delegate: self,
            pattern: patternsById[selectedPatternId!]!
        ).parse(
            url!,
            username: API["user"]!,
            password: API["password"]!
        )
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as SearchResult
        
        let pattern = patterns[indexPath.row]
        patternsById[pattern.id!] = pattern

        cell.pattern = pattern
        cell.cellLabel.text = pattern.name
        cell.cellImage.image = pattern.getThumbnail()
        //println("Cell Text \(cell.cellLabel.text)")

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var label = UILabel()
        label.text = "Search results for: '\(searchString)'"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(
            name: "BebasNeueBook",
            size: 16
        )
        
        return label
    }
    */
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        var button = UIButton()
        button.titleLabel!.text = "See next 10 results for: '\(searchString)'"
        button.titleLabel!.textAlignment = NSTextAlignment.Center

        button.titleLabel!.font = UIFont(
            name: "BebasNeueBook",
            size: 16
        )
        
        return button
    }
}