//
//  SearchResultsParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/28/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import Foundation

class SearchResultsParser<T>: JSONParser<T>, AsyncLoaderDelegate {
    
    var patterns = [Pattern]()
    
    override init() {
        super.init()
    }
    
    override func parse(json: NSDictionary) {
        var pattern_author: Author?
        var pattern_photo: Mipmap?
        var pattern_sources = [PatternSource]()
        var name: String?
        
        if let patterns = json["patterns"] as? NSArray {
            for pattern in patterns {
                
                name = pattern["name"] as String?
                
                if let author: NSDictionary = pattern["pattern_author"] as? NSDictionary {
                    
                    let id: Int = author["id"] as Int
                    
                    let patterns_count: Int = author["patterns_count"] as Int
                    
                    let permalink: NSURL? = NSURL(fileURLWithPath: author["permalink"] as String)
                    
                    if let users: NSArray = author["users"] as? NSArray {
                        for user in users {
                            /*
                            let id: Int = user["id"] as Int
                            let large_photo_url: String? = user["large_photo_url"] as String?
                            let photo_url: String? = user["photo_url"] as String?
                            let small_photo_url: String? = user["small_photo_url"] as String?
                            let tiny_photo_url: String? = user["tiny_photo_url"] as String?
                            let username: String = user["username"] as String
                            */
                        }
                    }
                    
                    let favorites_count: Int = author["favorites_count"] as Int
                    let name: String? = author["name"] as String?
                    
                    pattern_author = Author(
                        id: id,
                        name: name,
                        permalink: permalink,
                        patterns_count: patterns_count,
                        favorites_count: favorites_count
                    )
                } else {
                    pattern_author = Author()
                }
                
                
                if let photo: NSDictionary = pattern["first_photo"] as? NSDictionary {
                    pattern_photo = Mipmap(
                        small: photo["small_url"] as String?,
                        medium: photo["medium_url"] as String?,
                        square: photo["square_url"] as String?,
                        thumbnail: photo["thumbnail_url"] as String?
                    )
                } else {
                    pattern_photo = Mipmap()
                }
                
                
                if let sources: NSDictionary = pattern["pattern_sources"] as? NSDictionary {
                }
                
                var newPattern = Pattern(
                    id: pattern["id"] as Int,
                    name: name!,
                    author: pattern_author!,
                    photo: pattern_photo!,
                    sources: pattern_sources
                )
                
                newPattern.loaderDelegate = self
                
                self.patterns.append(newPattern)
            }
        }
    }
    
    override func loadComplete(object: AnyObject) {
        ++patternsLoaded
        //println("Pattern has loaded \(patternsLoaded) \\ \(self.patterns.count)")
        if self.patterns.count == patternsLoaded {
            //println("Patterns Have finished Loading ...")
            loaderDelegate!.loadComplete(self)
        }
    }
    
    private
    var patternsLoaded: Int = 0
}