//
//  PatternParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//


import UIKit

class PatternParser<T>: RavelryJSONParser<T>
{
    var pattern: Pattern?
    var mipmapsLoaded: Int = 0
    init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate, pattern: Pattern) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
        self.pattern = pattern
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        if let p = json["pattern"] as? NSDictionary {
            parsePattern(p)
        }
        return self
    }
    
    func parsePattern(p: NSDictionary) {
        pattern!.yarnWeightDescription = p["yarn_weight_description"] as? String
        
        pattern!.yardageMax = p["yardage_max"] as? Float
        pattern!.gaugePattern = p["gauge_pattern"] as? String
        pattern!.notes = p["notes"] as? String
        pattern!.yardage = p["yardage_description"] as? String
        pattern!.gauge = p["gauge"] as? Float
        pattern!.gaugeDivisor = p["gauge_divisor"] as? Float
        pattern!.gaugeDescription = p["gauge_description"] as? String
        if let location = p["download_location"] as? NSDictionary {
            pattern!.downloadURL = (location["url"] as String).toURL()
        }
        
        if let needles = p["pattern_needle_sizes"] as? NSArray {
            for needle in needles {
                pattern!.needles.append(parseNeedleSize(needle as NSDictionary))
            }
        }
        
        if let packs = p["packs"] as? NSArray {
            for pack in packs {
                pattern!.packs.append(parsePack(pack as NSDictionary))
            }
        }

        if let dlLocation = p["download_location"] as? NSDictionary {
            if let download = dlLocation["url"] as? String {
                
                pattern!.downloadLocation = NSURL(string: download)
                
                if let free = dlLocation["free"] as? Bool {
                    pattern!.flags |= (free) ? pattern!.IS_FREE_DOWNLOAD : 0
                }
                
                if let ravelry = dlLocation["ravelry"] as? Bool
                {
                    pattern!.flags |= (ravelry) ? pattern!.IS_RAVELRY_DOWNLOAD : 0
                }
                
                
            }
        }
        
        pattern!.ratingCount = p["rating_count"] as? Int
        
        if let pdf = p["pdf_url"] as? String {
            if pdf.match("http") != nil {
                pattern!.pdfURL = NSURL(string: pdf)
            }
        }
        pattern!.favoritesCount = p["favorites_count"] as? Int
        
        if let categories = p["pattern_categories"] as? NSArray {
            for category in categories {
                if let newCategory = parseCategory(category as? NSDictionary) {
                    pattern!.categories.append(newCategory)
                }
            }
        }
        
        pattern!.photos = parsePhotos(p["photos"] as? NSArray)
    }
    
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        
        if remaining == total {
            
            if total > 0 {
                ++mipmapsLoaded
            }
            
            //println("\(mipmapsLoaded) out of \(pattern?.photos.count) Mipmaps Loaded")
            if mipmapsLoaded == pattern?.photos.count {
                aDelegate!.loadComplete(self, action: .PatternRetrieved)
            }
        }
    }
    
}