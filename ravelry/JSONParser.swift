//
//  JSONParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/16/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class JSONParser<T>: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    override init() {
        super.init()
    }
    
    func parse(json: NSDictionary) -> JSONParser<T> {
        return self
    }
    
    func loadData(path: String) -> JSONParser<T> {
        let path = NSBundle.mainBundle().pathForResource(path, ofType: "json")
        println("Path \(path)")
        return loadData(NSData(
            contentsOfFile: path!,
            options: .DataReadingMappedIfSafe,
            error: nil
        ))
    }

    func loadData(data: NSData?) -> JSONParser<T> {

        if data != nil {
            
            var parseError: NSError?
            if let json = NSJSONSerialization.JSONObjectWithData(
                data!,
                options: nil,
                error: &parseError
                ) as? NSDictionary {
                    return self.parse(json)
            }
            println("Could Not Initialize JSON Data: \(parseError)")
        } else {
            println("Data was nil")
        }
        
        return self
    }
}