//
//  UIApplication.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

extension UIApplication {

    class func getTopmostViewController() -> UIViewController {
        println("Get Topmost View Controller")
        var topViewController = UIApplication.sharedApplication().keyWindow!.rootViewController
        
        while let controller = topViewController!.presentedViewController {
            topViewController = controller
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            for subcontroller in tabBarController.viewControllers! {
                //println("SubControllers:")
                //println(subcontroller.view)
                if let subcontrollerView = subcontroller.view {
                    //println(subcontrollerView)
                    //println(subcontrollerView!)
                    if subcontrollerView!.window != nil && subcontroller.isViewLoaded() {
                        if subcontroller.isViewLoaded() {
                            topViewController = subcontroller as? UIViewController
                            break;
                        }
                    }
                }
            }
        }

        return topViewController!
    }
}