//
//  ModalSwipeNavigator.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/10/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum ModalSwipeAction: String {
    case SlideSelected = "SlideSelected"
    case SlidesCleared = "SlidesCleared"
    case NoAction = "NoAction"
}

class ModalSwipeNavigator: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var action: ModalSwipeAction = .NoAction
    var transitionLocked: Bool = false
    var currentSlideIndex: Int = 0
    var slides = [UIImage]()
    
    override func viewDidLoad() {
        imageView.image = slides[currentSlideIndex]

        var leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("showLastSlide:"))
        var rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("showNextSlide:"))
        
        leftEdge.edges = .Right
        rightEdge.edges = .Left
        
        self.view.addGestureRecognizer(leftEdge)
        self.view.addGestureRecognizer(rightEdge)
    }
    
    @IBAction func showNextSlide(sender: UIScreenEdgePanGestureRecognizer) {
        if slides.count > currentSlideIndex + 1 && !transitionLocked {
            transitionLocked = true
            ++currentSlideIndex
            transitionSlide()
        }
    }
    
    @IBAction func showLastSlide(sender: UIScreenEdgePanGestureRecognizer) {
        if currentSlideIndex > 0 && !transitionLocked {
            transitionLocked = true
            --currentSlideIndex
            transitionSlide()
        }
        
    }
    
    func transitionSlide(type: NSString = kCATransitionMoveIn) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setCompletionBlock {
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * NSTimeInterval(NSEC_PER_SEC)))
            
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.imageView.startAnimating()
                self.transitionLocked = false
            }
        }
        
        let transition = CATransition()
        transition.type = type
        
        imageView.layer.addAnimation(transition, forKey: kCATransition)
        imageView.image = slides[currentSlideIndex]
        
        CATransaction.commit()
    }
}