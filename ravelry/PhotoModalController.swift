//
//  PhotoModalController.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/4/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

protocol PhotoSelectorDelegate {
    func photoWasSelected(photo: UIImage?, action: ModalSwipeAction)
}

class PhotoModalController: ModalSwipeNavigator {
    
    var delegate: PhotoSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func destroyPhoto(sender: UIButton) {
        doAsync {
            var dialogue = DialogueController(
                title: "Delete Photo",
                message: "Are you sure you want to do this?"
            )
            
            dialogue.addAction("OK") { (action) in
                self.slides.removeAtIndex(self.currentSlideIndex)
                
                if self.slides.count > 0 {
                    self.transitionLocked = true
                    self.currentSlideIndex = (self.currentSlideIndex > 0) ? self.currentSlideIndex - 1 : 0
                    self.transitionSlide(type: kCATransitionFade)
                } else {
                    if let d = self.delegate {
                        d.photoWasSelected(nil, action: .SlidesCleared)
                    }
                    self.backToCamera(sender)
                }
            }
            
            dialogue.addCancelAction()
            dialogue.present(context: self)
        }
        
    }
    
    @IBAction func acceptPhoto(sender: UIButton) {
        
        doAsync {
            var dialogue = DialogueController(
                title: "Add Photo",
                message: "Add this photo to your project?"
            )
            
            dialogue.addAction("OK") { (action) in
                self.slides = [self.slides[self.currentSlideIndex]]
                if let d = self.delegate {
                    d.photoWasSelected(
                        self.slides[0],
                        action: .SlideSelected
                    )
                }
                
                self.backToCamera(sender)

            }
            
            dialogue.addCancelAction()
            
            dialogue.present(context: self)
        }
    }
    
    @IBAction func backToCamera(sender: UIButton) {
        dismissViewControllerAnimated(true) {
            
        }
    }
}