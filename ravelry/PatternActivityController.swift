//
//  PatternActivityController.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/8/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class PatternActivityController: UIActivityViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(context: UIViewController, pattern: Pattern) {

        var appActivities = [UIActivity]()

        if ravelryUser!.hasProject(pattern.id) {
            appActivities.append(ViewProject(pattern: pattern))
        } else {
            appActivities.append(AddToProjects(pattern: pattern))
        }

        if ravelryUser!.hasProjectInQueue(pattern.id) {
            appActivities.append(Dequeue(pattern: pattern))
        } else {
            appActivities.append(AddToQueue(pattern: pattern))
        }
        
        if ravelryUser!.hasFavorite(pattern.id) {
            appActivities.append(Unfavorite(pattern: pattern))
        } else {
            appActivities.append(Favorite(pattern: pattern))
        }
        
        
        if pattern.pdfURL != nil {
            appActivities.append(ViewPDF(pattern: pattern))
        }
        
        if pattern.downloadURL != nil {
            appActivities.append(ViewPDF(pattern: pattern))
        }
        
        
        var actItems = [AnyObject]()
        
        super.init(
            activityItems: actItems,
            applicationActivities: appActivities
        )
        
        for app in appActivities {
            (app as BaseRavelryActivity).context = context
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}