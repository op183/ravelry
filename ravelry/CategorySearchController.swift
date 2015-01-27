//
//  CategorySearchController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategorySearchController: BaseRavelryTableViewController, UITableViewDelegate, UITableViewDataSource {

    //green : 131	189	167
    //orange : 239	160	15	
    //pale : 198	214	187	
    //gold : 248	209	43	
    //brown : 133	95	58
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

    }
    
    func getType(key: String) -> CategoryType {
        switch key {
        case "Attributes": return CategoryType.Attribute
        case "Weight": return CategoryType.Weight
        case "Hook Size": return CategoryType.HookSize
        case "Yardage": return CategoryType.Yardage
        default: return CategoryType.Category
        }
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

    /*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var h = CGFloat(44.0)
        var w = tableView.frame.width
        
        var view = UIView(frame: CGRectMake(0, 0, w, h))
        var label = UILabel(frame: CGRectMake(0, 0, 100, h))
        var plus = UILabel(frame: CGRectMake(0, 0, 20, h))

        let bebas = UIFont(
            name: "BebasNeueBold",
            size: 20
        )
        
        label.font = bebas
        plus.font = bebas
        label.text = categories[section].name!
        plus.text = "+"
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        plus.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(plus)
        view.addSubview(label)
        view.userInteractionEnabled = true

        
        let cellMarginX = NSLayoutConstraint(
            item: plus,
            attribute: .LeftMargin,
            relatedBy: .GreaterThanOrEqual,
            toItem: view,
            attribute: .LeftMargin,
            multiplier: 1,
            constant: 20
        )
        
        view.addConstraint(cellMarginX)
        
        let titleMarginX = NSLayoutConstraint(
            item: label,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: plus,
            attribute: .Trailing,
            multiplier: 1,
            constant: 15
        )
        

        view.addConstraint(titleMarginX)


        return view
    }
    */
    
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
            cell.backgroundColor = UIColor(
                red: CGFloat(254.0/255.0),
                green: CGFloat(221.0/255.0),
                blue: CGFloat(108/255.0),
                alpha: CGFloat(1.0)
            )
        } else {
            cell.backgroundColor = UIColor(
                red: CGFloat(1.0),
                green: CGFloat(1.0),
                blue: CGFloat(1.0),
                alpha: CGFloat(1.0)
            )
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.row
        var category = categories[index]
        var cell = tableView.cellForRowAtIndexPath(indexPath) as CategoryTableViewCell
        
        if category.children.count > 0 {
            if !expandedCells[category.index]! {
                println("Expanding \(category.name): \(category.index)")

                expandedCells[category.index] = true
                cell.switcher.text = "-"
                
                for child in category.children {
                    visibleCells[child.index] = true
                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: child.index, inSection: 0)) {
                        cell.hidden = false
                    }
                }
                
            } else {
                println("Reducing \(category.name): \(category.index)")
                cell.switcher.text = "+"
                reduceCell(category)
            }
        } else {
            if selectedCells[category.index]! {
                println("Deselecting \(category.name!): \(category.index)")
                query.removeParameter(category.name!, category.type!)
                cell.backgroundColor = UIColor(
                    red: CGFloat(1.0),
                    green: CGFloat(1.0),
                    blue: CGFloat(1.0),
                    alpha: CGFloat(1.0)
                )
            } else {
                println("Selecting \(category.name!): \(category.index)")
                query.addParameter(category.name!, category.type!)
                cell.backgroundColor = UIColor(
                    red: CGFloat(254.0/255.0),
                    green: CGFloat(221.0/255.0),
                    blue: CGFloat(108/255.0),
                    alpha: CGFloat(1.0)
                )
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
    
    func resultsHaveBeenFetched(data: NSData!, action: String) {
        
    }
    
    func loadComplete(object: AnyObject, action: String) {
        //self.performSegueWithIdentifier(segueAction, sender: self)
    }
}
