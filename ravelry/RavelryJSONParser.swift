//
//  RavelryJSONParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/24/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class RavelryJSONParser<T>: JSONParser<T>, MipmapLoaderDelegate {

    var mDelegate: MipmapLoaderDelegate?
    var aDelegate: AsyncLoaderDelegate?

    override init() {
        super.init()
    }

    init(aDelegate: AsyncLoaderDelegate) {
        super.init()
        self.aDelegate = aDelegate
    }
    
    init(mDelegate: MipmapLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init()
        self.aDelegate = aDelegate
        self.mDelegate = mDelegate
    }
    
    func parsePatternResult(pattern: NSDictionary) -> Pattern? {
        var pattern_author: Author?
        var pattern_photo: Mipmap?
        var pattern_sources = [PatternSource]()
        var name: String?
        
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
            pattern_photo = loadMipmap(photo)
        } else {
            checkProgress()
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
        return newPattern
    }
    
    func checkProgress(remaining: Int, _ total: Int) {
        
    }
    
    func checkProgress() {
        checkProgress(0, 0)
    }

    func loadMipmap(photo: NSDictionary?) -> Mipmap {
        var mipmap: Mipmap?
        if photo != nil {
            var s =  photo!["small_url"] as? String
            var m = photo!["medium_url"] as? String
            var thumbnail = photo!["thumbnail_url"] as? String
            var square = photo!["square_url"] as? String
            var shelved = photo!["shelved_url"] as? String
            
            mipmap = Mipmap(
                small: s,
                medium: m,
                thumbnail: thumbnail,
                square: square,
                shelved: shelved,
                delegate: self
            )
            
            mipmap!.setOffset(
                x: photo!["x_offset"] as? Int,
                y: photo!["y_offset"] as? Int
            )
            
            mipmap!.setSortOrder(photo!["sort_order"] as? Int)
        } else {
            mipmap = Mipmap(named: "missing-photo", delegate: self)
        }
        
        return mipmap!
    }

    func parseCategory(category: NSDictionary?) -> PatternCategory? {
        if let c = category {
            var pString = c["permalink"] as? String
            var permalink = NSURL(
                string: "http://www.ravelry.com/patterns/popular/\(pString)"
            )
            
            var name = c["name"] as? String
            var id = c["id"] as? Int
            var parent = parseCategory(c["parent"] as? NSDictionary)
            
            return PatternCategory(
                id: id,
                name: name,
                permalink: permalink,
                parent: parent
            )
        } else {
            return nil
        }
    }
    
    func filterValues(values: NSDictionary) -> [String: AnyObject?] {
        var obj = [String: AnyObject?]()
        
        for (key, value) in values as NSDictionary {
            if value is String && value as String == "<null>" {
                obj[key as String] = nil as AnyObject?
            } else {
                obj[key as String] = value as AnyObject?
            }
        }
        return obj
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        //println("\t\t\(remaining) out of \(total) Photos loaded!")
        if mDelegate != nil {
            mDelegate!.imageHasLoaded(remaining, total)
        }
    }
}