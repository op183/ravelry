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
    
    @IBAction func linkTouch(sender: UIButton) {
        
    }
    
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var yarnTitle: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var needleSizeTitle: UILabel!
    @IBOutlet weak var gaugeTitle: UILabel!
    @IBOutlet weak var yardageTitle: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var action = ""
        var imageName = ""
        
        if ravelryUser!.hasFavorite(pattern!.id) {
            action = "unfavoritePattern:"
            imageName = "unfavorite"
        } else {
            action = "favoritePattern:"
            imageName = "favorite"
        }

        var menuButtons: [UIBarButtonItem] = [
            UIBarButtonItem(
                image: UIImage(named: imageName),
                style: .Plain,
                target: self,
                action: Selector(action)
            )
        ]
        
        if pattern!.pdfURL != nil {
            menuButtons.append(
                UIBarButtonItem(
                    image: UIImage(named: "pdf"),
                    style: .Plain,
                    target: self,
                    action: Selector("selectPDF:")
                )
            )
        }

        if pattern!.downloadURL != nil {
            menuButtons.append(
                UIBarButtonItem(
                    image: UIImage(named: "download"),
                    style: .Plain,
                    target: self,
                    action: Selector("selectDownload:")
                )
            )
        }

        navigationItem.setRightBarButtonItems(menuButtons, animated: true)

        photoCollection.dataSource = self
        
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
        if pattern!.yarnWeightDescription != nil {
            yarnTitle.text = pattern!.yarnWeightDescription
        } else {
            for yarn in pattern!.yarns {
                if yarn.name != nil {
                    yarnTitle.text! += yarn.name! + "; "
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "patternImage",
                forIndexPath: indexPath
            ) as? PatternPhotoCell
        
        cell!.setMipmap(pattern!.getMipmapAtIndex(indexPath.row)!)
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: Selector("selectImageForPopover:"))
        cell!.addGestureRecognizer(tap)
        return cell!
    }

    @IBAction func unfavoritePattern(sender: AnyObject) {
        ravelryUser!.destroyFavorite(pattern!.id, delegate: self)
    }
    
    @IBAction func favoritePattern(sender: AnyObject) {
        let alert = DialogueController(
            title: "Favorite \(pattern!.name)?",
            message: ""
        )
        
        alert.addTextField(placeholder: "Notes")
        alert.addTextField(placeholder: "Tags")
        alert.addCancelAction()
        
        alert.addAction("Save", handler: {(action: UIAlertAction!) in
            
            var comment: String = alert.getTextFieldAtIndex(0)
            var tags: String = alert.getTextFieldAtIndex(1)

            ravelryUser?.addFavorite(self.pattern!, comment: comment, tags: tags, delegate: self)
        })
        alert.present(context: self)
    }
    
    @IBAction func selectImageForPopover(sender: UIGestureRecognizer) {
        println("Selecting Image View")

        var popover = self.storyboard?.instantiateViewControllerWithIdentifier("patternImagePopover") as? ImagePopover
        
        var selectedImage = (sender.view as? PatternPhotoCell)!.getMipmap()

        popover!.selectedImage = selectedImage

        popover!.modalPresentationStyle = .Popover
        
        
        popover!.preferredContentSize = CGSizeMake(300, 300)
        if let presentationController = popover!.popoverPresentationController {
            presentationController.delegate = self
            presentationController.permittedArrowDirections = .Up
            presentationController.sourceView = sender.view
            presentationController.sourceRect = CGRectMake(0, 0, 50, 50)
            self.presentViewController(popover!, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectPDF(sender: AnyObject) {
        println("PDF Selected")
    }
    
    @IBAction func selectDownload(sender: AnyObject) {
        segueAction = "selectDownload";
        performSegueWithIdentifier("showPatternLink", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controller = segue.destinationViewController as? PatternDownloadController
        switch segueAction {
            case "selectDownload":
                controller!.link = self.pattern!.downloadLocation
            default:
                println("'\(segueAction)' is not an authorized action!")
            
        }
        segueAction = ""
    }
    
    func resultsHaveBeenFetched(results: NSData!, action: String) {
        switch action {
        case "FavoritePattern":
            println("Pattern has been favorited")
        case "DestroyPattern":

            println("Pattern has been deleted")
        default:
            println("\(action) is not a recgonized action.")
        }
    }

    
}