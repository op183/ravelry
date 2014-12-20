//
//  JSONParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/16/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

@objc protocol JSONParserDelegate {
    
}

class JSONParser: NSObject, NSURLConnectionDelegate {
    
    var delegate: JSONParserDelegate?
    let encodedAuth = "070C505B63E50C3BAD3D:_jP_2lOVBjSsYtC36hYacGbpjohCtzr8HSdzJBE2".base64
    
    override init() {
        super.init()
    }
    
    func parse(url: NSURL) {
        let request = NSMutableURLRequest(URL: url)
        request.addValue("Basic \(encodedAuth)", forHTTPHeaderField: "Authorization")
        
        let connection = NSURLConnection()
        
        NSURLConnection(
            request: request,
            delegate: self,
            startImmediately: true
            )?.start()
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {

        //var s: String = NSString(data: data, encoding: NSUTF8StringEncoding) as String
        //println("Connection Received Data \(s)")

        var parseError: NSError?
        //NSJSONReadingOptions.AllowFragments | NSJSONReadingOptions.MutableContainers | NSJSONReadingOptions.MutableLeaves
        if let json = NSJSONSerialization.JSONObjectWithData(
            data,
            options: nil,
            error: &parseError
            ) as? NSDictionary {
                
                if let patterns = json["patterns"] as? NSArray {
                    for pattern in patterns {
                        println(pattern.name)
                    }
                }
        } else {
            println("Could Not Initialize JSON Data: \(parseError)")
        }
        
        //println(parsedObject)
        
    }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println("Connection Received Response")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Connection Failed with Error")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("Connection finished loading")
    }
    
}