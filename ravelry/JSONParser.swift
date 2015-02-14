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

        if let json = loadRaw(data) {
            return self.parse(json)
        } else {
            NSException(
                name: "JSONParserError",
                reason: "Could Not Initialize JSON Data",
                userInfo: nil
            )
        }
      
        return self
    }
    
    func loadRaw(data: NSData?) -> NSDictionary? {
        
        if data != nil {
            var parseError: NSError?
            return NSJSONSerialization.JSONObjectWithData(
                data!,
                options: nil,
                error: &parseError
            ) as? NSDictionary
        } else {
            println("Data was nil")
        }

        return nil
    }
}