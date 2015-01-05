//
//  Http.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/21/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class Http {
    
    
    class func request(urlString: String?, handler: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        if urlString != nil {
            var loc = urlString?.match("^(http|https):\\/\\/(.*?)(\\/.*$|$)")
            //println("Location: \(loc)")
            if loc != nil && loc!.count == 3 {
                var url = NSURL(
                    scheme: loc![0],
                    host: loc![1],
                    path: loc![2]
                )
                self.request(url, headers: nil, handler: handler)
            }
        }
    }
    
    class func request(url: NSURL?, handler: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        if url != nil {
            self.request(url, headers: nil, handler: handler)
        }
    }

    class func request(url: NSURL?, headers: [String: String]?, handler: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        if url != nil {
            
            var request = NSMutableURLRequest(URL: url!)
            
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            NSURLConnection.sendAsynchronousRequest(
                request,
                queue: NSOperationQueue.mainQueue(),
                completionHandler: handler
            )
            
        }
    }
    
    class func post() {
        
    }
    
    class func get() {
        
    }
    
    class func delete() {
    
    }
    
    class func put() {
        
    }
}