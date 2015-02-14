//
//  Threading.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/28/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

func delay(delay: Double, closure: ()->() ) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}

func runOnThread(selector: Selector, target: AnyObject, object: AnyObject? = nil) {
    NSThread(
        target: target,
        selector: selector,
        object: object
    ).start()
}

func doAsync(closure: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        closure()
    }
}

