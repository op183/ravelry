//
//  PatternView.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class PatternViewController: BaseRavelryTableViewController, NSURLConnectionDataDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, OAuthServiceResultsDelegate {
    var pattern: Pattern?
    var segueAction: String = ""
    var selectedImageIndex: Int = 0
    var photos = [UIImage]()
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var yarnTitle: UILabel!
    @IBOutlet weak var notesTitle: UITextView!
    @IBOutlet weak var needleSizeTitle: UILabel!
    @IBOutlet weak var gaugeTitle: UILabel!
    @IBOutlet weak var yardageTitle: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItem(
            UIBarButtonItem(
                image: UIImage(named: "circle-menu")!.doScaling(25, 25),
                style: .Plain,
                target: self,
                action: Selector("showPatternActivities:")
            ),
            animated: true
        )
        photos = pattern!.getFullsizeImages()
        
        photoCollection.dataSource = self
        photoCollection.delegate = self
        
        navTitle.title = pattern!.name
        
        if pattern!.gaugeDescription != nil {
            gaugeTitle.text = pattern!.gaugeDescription
        } else {
            if pattern!.gauge != nil {
                gaugeTitle.text = sprintf("%.2f", pattern!.gauge!)
            } else {
                gaugeTitle.text = ""
            }
        }
        
        
        needleSizeTitle.text = ""
        for needle in pattern!.needles {
            needleSizeTitle.text! += "\(needle.name); "
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
        if pattern!.yarnWeightDescription != nil {
            yarnTitle.text = pattern!.yarnWeightDescription
        } else {
            for pack in pattern!.packs {
                if let y = pack.yarn {
                    yarnTitle.text! += "\(y.name); "
                }
            }
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pattern!.getPhotoCount()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedImageIndex = indexPath.row
        
        println("Did Select \(indexPath.row)")
        
        if let popover = self.storyboard?.instantiateViewControllerWithIdentifier("patternImagePopover") as? ImagePopover {
            
            popover.currentSlideIndex = selectedImageIndex
            popover.slides = photos
            
            popover.modalPresentationStyle = .OverCurrentContext
            self.presentViewController(popover, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "patternImage",
                forIndexPath: indexPath
            ) as? PatternPhotoCell
        
        cell!.setPhotoSet(pattern!.getPhotoSetAtIndex(indexPath.row)!)

        return cell!
    }
    
    //Actions
    @IBAction func showPatternActivities(sender: AnyObject) {

        let activityVC = PatternActivityController(
            context: self,
            pattern: pattern!
        )
        var x = 0
        var y = (x == 0)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? PatternDownloadController {
            controller.link = self.pattern!.downloadLocation
        } else if let controller = segue.destinationViewController as? ProjectViewController {
            controller.projectId = (sender as ViewProject).project!.id
        } else if let controller = segue.destinationViewController as? PatternDownloadController {
            if let activity = sender as? ViewPDF {
                
            } else if let activity = sender as? ViewDownloadable {
                
            }
        } else {
            println("'\(segueAction)' is not an authorized action!")
        }

        segueAction = ""
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .PatternFavorited:
                println("Pattern has been favorited")
            default:
                println("\(action) is not a recgonized action.")
        }
    }

    
}