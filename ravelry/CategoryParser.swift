//
//  CategoryParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryParser<T>: RavelryJSONParser<T> {
    var categories = [String:AnyObject]()
    
    override init() {
        super.init()
    }

    
    override func parse(json: NSDictionary) -> CategoryParser<T> {
        for (k, v) in json as [String:AnyObject] {
            
            parseRecursive(&categories, key: k, value: v)
        }
        
        return self
    }

    func getCategories() -> [String:AnyObject] {
        return categories
    }
    
    override func loadData(string: String) ->CategoryParser<T> {
        super.loadData(string)
        return self
    }
    
    func parseRecursive(inout collection: [String:AnyObject], key: String, value: AnyObject) {
        //println("Parsing \(key)")
        if value is [String:AnyObject] {

            collection[key] = [String:AnyObject]()
            
            var category = collection[key] as [String:AnyObject]
            for (k, v) in value as [String:AnyObject] {
                parseRecursive(&category, key: k, value: v)
            }
            
            collection[key] = category
            
        } else if value is [String] {
            var strings = [String]()

            for v in value as [String] {
                strings.append(v as String)
            }
            
            collection[key] = strings
        }
    }
    
    
}