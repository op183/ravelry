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

    var images = [NSURL]()
    
    convenience init() {
        self.init(
            cats: ["title", "link", "description", "pubDate"],
            parent: "item",
            node: "item"
        )
    }
    
    func parseDescription(description: String) {
        var files = description.match("<img .*?src=['\"](.*?)['\"].*?>")
        
        if files != nil {
            for file in files! {
                println("Image: \(file)")
                
                var matches: [String]? = file.match("(http|https):\\/\\/(.*?)(\\/.*)");
                
                if matches != nil && matches!.count == 3 {
                    var url = NSURL(
                        scheme: matches![0],
                        host: matches![1],
                        path: matches![2]
                    )
                    if url != nil {
                        images.append(url!)
                    }
                }
            }
        }
        
        fields["description"] = description.gsub("<.*?>", "")
    }
}