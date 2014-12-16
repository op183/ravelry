//
//  RavelryXMLParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/13/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class RavelryXMLParser: XMLParser {
    
    var fields = [
        "title": "",
        "link": "",
        "description": "",
        "pubDate": ""
    ]

    var images = [String]?()
    
    convenience init() {
        self.init(
            cats: ["title", "link", "description", "pubDate"],
            parent: "item",
            node: "item"
        )
    }
    
    func parseDescription(description: String) -> String {
        images = description.match(";ltimg .*?src=['\"](.*?)['\"].*?(?:;gt)")
        fields["description"] = description.gsub(";lt.*?;gt", "")
        println("Description \(fields[description])")
        
        if images != nil {
            for image in images! {
                println("Image: \(image)")
            }
        }
        
        return fields["description"]!
    }
}