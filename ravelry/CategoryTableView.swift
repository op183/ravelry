//
//  CategoryTableView.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryTableView: UITableView {
 
    
    override func didAddSubview(subview: UIView) {
        super.didAddSubview(subview)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //println("Layout Subviews")
    }
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        //println("Set Needs Display")
    }
 
    override func setNeedsLayout() {
        super.setNeedsLayout()
        //println("Set Needs Layout")
    }
}