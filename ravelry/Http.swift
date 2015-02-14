//
//  Http.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/21/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit
typealias URLSessionHandler = (data: NSData!, response: NSURLResponse!, error: NSError!) -> ()

class Http {
    
    
    class func request(urlString: String, handler: URLSessionHandler) {
        if let URL = NSURL(string: urlString) {
            self.request(URL, headers: nil, handler: handler)
        }
    }
    
    class func request(url: NSURL?, handler: URLSessionHandler) {
        if url != nil {
            self.request(
                url,
                headers: nil,
                handler: handler
            )
        }
    }

    class func request(url: NSURL?, headers: [String: String]?, handler: URLSessionHandler) {
        self.request(
            url,
            headers: headers,
            params: nil,
            handler: handler
        )
    }
    
    class func request(url: NSURL?, headers: [String: String]?, params: [String:String]?, method: String = "GET", handler: URLSessionHandler) {
        if url != nil {
            
            var request = getRequest(url!, method: method)
            
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }

            getSession().dataTaskWithRequest(request,
                completionHandler: handler
            ).resume()
        }
    }
    
    class func post(URL: String, params: [String:String]?, handler: URLSessionHandler) {
        self.request(
            NSURL(string: URL),
            headers: nil,
            params: params,
            method: "POST",
            handler: handler
        )
    }
    
    
    class func get(URL: String, params: [String:String]?, handler: URLSessionHandler) {
        self.request(
            NSURL(string: URL),
            headers: nil,
            params: params,
            method: "GET",
            handler: handler
        )
    }
    
    class func delete() {
    
    }
    
    class func put() {
        
    }
    
    class func getRequest(URL: NSURL, method: String) -> NSMutableURLRequest {
        var request = NSMutableURLRequest(
            URL: URL,
            cachePolicy: .ReturnCacheDataElseLoad,
            timeoutInterval: 60
        )
        
        request.HTTPMethod = method
        request.HTTPShouldHandleCookies = false
        return request
    }
    
    class func getSession() -> NSURLSession {
        var sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        var session = NSURLSession(configuration: sessionConfig)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return session
    }
}