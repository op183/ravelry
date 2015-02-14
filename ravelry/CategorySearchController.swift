//
//  CategorySearchController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategorySearchController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var categories = [PatternCategory]()
    var query = QueryBuilder()
    var index = 0
    
    var expandedCells = [Int:Bool]()
    var selectedCells = [Int:Bool]()
    var visibleCells = [Int:Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for (k, v) in ravelryCategories {
            setCategory(k, v, type: getType(k))
        }
        
        let searchButton = UIBarButtonItem(
            title: "GO",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("searchPatterns:")
        )
        
        searchButton.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: "BebasNeueBold", size: 24)!,
                NSForegroundColorAttributeName: UIColor.blackColor()
            ],
            forState: UIControlState.Normal
        )

        
        navigationItem.setRightBarButtonItem(searchButton, animated: true)
        var searchBar = UISearchBar()
        searchBar.imageForSearchBarIcon(.Clear, state: .Normal)
        searchBar.returnKeyType = .Done
        
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        println("Search Bar Should End Editing")
        return true
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("Search Bar Did Begin Editing")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("Search Bar Text Did Change: \(searchText)")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Done: \(searchBar.text)")
        query.addParameter(searchBar.text, .None)
        searchBar.resignFirstResponder()
    }
    
    
    
    func getType(key: String) -> CategoryType {
        return CategoryType(rawValue: key)!
    }
    
    
    func setCategory(key: String, _ value: AnyObject? = nil, type: CategoryType, parent: PatternCategory? = nil, tabs: Int = 0) -> PatternCategory {
        var tstring = ""

        for t in 0...tabs {
            tstring += "\t"
        }
        
        
        //println("\(tstring)\(key): \(index)")

        var category = PatternCategory(name: key, parent: parent, index: index++, type: type)
        categories.append(category)

        if parent == nil {
            visibleCells[category.index] = true
        } else {
            visibleCells[category.index] = false
        }
        
        expandedCells[category.index] = false
        selectedCells[category.index] = false

        if value is [String:AnyObject]{
            //println("\(key) is Dictionary")
            //cell = CategoryTableViewCell(category: key, subsections: value as [String:AnyObject])
            for (k, v) in value as [String:AnyObject] {
                category.setChild(setCategory(k, v, type: type, parent: category, tabs: tabs + 1))
            }

           //buildSubviews(value as [String:AnyObject])
        } else if value is [String]{
            //println("\(key) is Array")
            
            //cell = CategoryTableViewCell(category: key, subcategories: value as [String])
            for v in value as [String] {
                category.setChild(setCategory(v, nil, type: type, parent: category, tabs: tabs + 1))
            }
        } else {
            
        }
        
        return category
    }
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    */
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = CollectionFilterHeaderView()

        view.crochetButton!.addTarget(
            self,
            action: Selector("filterResultsForCrochet:"),
            forControlEvents: .TouchUpInside
        )

        view.knittingButton!.addTarget(
            self,
            action: Selector("filterResultsForKnitting:"),
            forControlEvents: .TouchUpInside
        )

        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(75.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var category = categories[indexPath.row]

        if visibleCells[category.index]! {
            return CGFloat(30.0)
        } else {
            return CGFloat(0.0)
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var category = categories[indexPath.row]
        var reuseId = "categoryView"
        var name = category.name!
        if category.children.count == 0 {
            reuseId = "selectableCategoryView"
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as CategoryTableViewCell
        
        cell.labeler.text = name

        if !visibleCells[category.index]! {
            cell.hidden = true
        }
        
        if selectedCells[category.index]! {
            cell.backgroundColor = Color.saffron.uiColor
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.row
        var category = categories[index]
        var cell = tableView.cellForRowAtIndexPath(indexPath) as CategoryTableViewCell
        
        if category.children.count > 0 {
            if !expandedCells[category.index]! {
                //println("Expanding \(category.name): \(category.index)")

                expandedCells[category.index] = true
                cell.switcher.text = "-"
                
                for child in category.children {
                    visibleCells[child.index] = true
                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: child.index, inSection: 0)) {
                        cell.hidden = false
                    }
                }
                
            } else {
                //println("Reducing \(category.name): \(category.index)")
                cell.switcher.text = "+"
                reduceCell(category)
            }
        } else {
            if selectedCells[category.index]! {
                //println("Deselecting \(category.name!): \(category.index)")
                query.removeParameter(category.name!, category.type!)
                cell.backgroundColor = UIColor.whiteColor()
            } else {
                //println("Selecting \(category.name!): \(category.index)")
                query.addParameter(category.name!, category.type!)
                cell.backgroundColor = Color.saffron.uiColor
            }
            selectedCells[category.index] = !selectedCells[category.index]!
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func reduceCell(category: PatternCategory) {
        expandedCells[category.index] = false
        for child in category.children {
            visibleCells[child.index] = false
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: child.index, inSection: 0)) {
                cell.hidden = true
                for grandchild in child.children {
                    if visibleCells[grandchild.index]! {
                        reduceCell(child)
                    }
                }
            }
        }
    }
    
    func toggleButton(button: UIButton, queryParameter: String, queryType: CategoryType) {
        
        println("Button is Enabled: \(button.selected)")
        
        button.selected = !button.selected
        if button.selected {
            selectButton(button)
            query.addParameter(queryParameter, queryType)
        } else {
            deselectButton(button)
            query.removeParameter(queryParameter, queryType)
        }
    }
    
    func selectButton(button: UIButton) {
        button.backgroundColor = Color.saffron.uiColor
    }
    
    func deselectButton(button: UIButton) {
        button.backgroundColor = Color.silver.uiColor
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
    }
    
    @IBAction func filterResultsForCrochet(sender: UIButton) {
        toggleButton(sender, queryParameter: "crochet", queryType: .Craft)
    }

    @IBAction func filterResultsForKnitting(sender: UIButton) {
        toggleButton(sender, queryParameter: "knitting", queryType: .Craft)
    }

    @IBAction func searchPatterns(sender: AnyObject) {
        performSegueWithIdentifier("showCategoryDetailView", sender: self)
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Preparing for Segue")
        if let navController = segue.destinationViewController as? UINavigationController {
            
            if let collectionController = navController.viewControllers[0] as? CategoryCollectionController {
                
                if let svc = splitViewController {
                    
                    let searchButton = UIBarButtonItem(
                        image: UIImage(named: "magnifying-glass"),
                        style: UIBarButtonItemStyle.Plain,
                        target: svc.displayModeButtonItem().target,
                        action: svc.displayModeButtonItem().action
                    )
                    
                    //collectionController.navigationItem.leftBarButtonItem = searchButton
                    collectionController.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
                    
                }
                
                collectionController.pageCount = 2
                collectionController.queryParams = query.getParams(["page_size": MAX_PATTERNS_PER_PAGE])
                
                collectionController.showLoader()

                mOAuthService.getPatterns(
                    collectionController.queryParams,
                    delegate: collectionController
                )
            }
        }
    }
}
