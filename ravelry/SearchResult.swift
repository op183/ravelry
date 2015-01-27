//
//  SearchResult.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SearchResult: UITableViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var pattern: Pattern?

}