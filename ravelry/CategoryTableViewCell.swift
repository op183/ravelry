//
//  CategoryTableViewCell.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labeler: UILabel!
    @IBOutlet weak var switcher: UILabel!

    //var label = UILabel(frame: CGRectMake(0, 0, 0, 0))
    //var toggle: UIButton?
    var category = ""
    /*
    var subcategories = [AnyObject]()
    var subsections = [String:AnyObject]()

    init(_ category: String) {
        super.init(frame: frameRect)
        self.category = category
        
        label.font = UIFont(
            name: "BebasNeueBold",
            size: 20
        )
        
        label.text = "+ \(category)"
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(label)
        
        let cellCenterY = NSLayoutConstraint(
            item: label,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0
        )
        
        contentView.addConstraint(cellCenterY)
        
        let cellMarginX = NSLayoutConstraint(
            item: label,
            attribute: .LeftMargin,
            relatedBy: .GreaterThanOrEqual,
            toItem: contentView,
            attribute: .LeftMargin,
            multiplier: 1,
            constant: 10
        )
        
        contentView.addConstraint(cellMarginX)

    }
    
    convenience init(category: String, subcategories: [String]) {
        self.init(category)
        self.subcategories = subcategories
    }
    
    convenience init(category: String, subsections: [String:AnyObject]) {
        self.init(category)
        self.subsections = subsections
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }
    
    private
    var frameRect = CGRectMake(0, 0, 0, 44)
    */
    
}