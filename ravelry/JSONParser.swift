//
//  JSONParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/16/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class JSONParser<T>: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate, AsyncLoaderDelegate {
    
    var loaderDelegate: AsyncLoaderDelegate?
    
    override init() {
        super.init()
    }

    init(delegate: AsyncLoaderDelegate) {
        super.init()
        loaderDelegate = delegate
    }


    func parse(url: NSURL, username: String, password: String) {
        let request = NSMutableURLRequest(URL: url)
        let encodedAuth = "Basic " + "\(username):\(password)".base64;
        
        request.addValue(encodedAuth, forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: NSOperationQueue.mainQueue()
        ) { (response, data, error) in

            var parseError: NSError?
            if data != nil {
                if let json = NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: nil, //NSJSONReadingOptions.AllowFragments | NSJSONReadingOptions.MutableContainers | NSJSONReadingOptions.MutableLeaves
                    error: &parseError
                    ) as? NSDictionary {
                        self.parse(json)
                } else {
                    println("Could Not Initialize JSON Data: \(parseError)")
                }
            } else {
                println("No data returned from server: \(error)")
            }
            
        }
    }
        
    func parse(json: NSDictionary) {
        
    }
    
    func readFullString(data: NSData) {
        var s: String = NSString(data: data, encoding: NSUTF8StringEncoding) as String
        println("Connection Received Data \(s)")
    }
    
    func loadComplete(object: AnyObject) {
        loaderDelegate?.loadComplete(self)
    }
}