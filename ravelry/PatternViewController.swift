//
//  PatternView.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class PatternViewController: BaseRavelryTableViewController {
    var pattern: Pattern?
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var yarnTitle: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var needleSizeTitle: UILabel!
    @IBOutlet weak var gaugeTitle: UILabel!
    @IBOutlet weak var yardageTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(pattern)
        navTitle.title = pattern!.name
        
        if pattern!.gauge != nil {
            gaugeTitle.text = sprintf("%.2f", pattern!.gauge!)
        } else {
            gaugeTitle.text = ""
        }
        
        needleSizeTitle.text = ""
        for needle in pattern!.needles {
            if needle.name != nil {
                needleSizeTitle.text! += needle.name! + "; "
            }
        }

        if pattern!.notes != nil {
            notesTitle.text = pattern!.notes!
        } else {
            notesTitle.text = ""
        }

        if pattern!.yardage != nil {
            yardageTitle.text! = pattern!.yardage!
        } else {
            yardageTitle.text! = ""
        }
        
        yarnTitle.text! = ""
        for yarn in pattern!.yarns {
            if yarn.name != nil {
                yarnTitle.text! += yarn.name! + "; "
            }
        }
    }
    
    
}