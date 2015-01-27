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
    init(mDelegate: MipmapLoaderDelegate, aDelegate: AsyncLoaderDelegate, pattern: Pattern) {
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
                var n = filterValues(needle as NSDictionary)
                
                pattern!.needles.append(Needle(
                    hook: n["hook"] as? String,
                    USSize: n["us"] as? String,
                    USSteel: n["us_steel"] as? String,
                    metricSize: n["metric"] as? Float,
                    knitting: n["knitting"] as? Bool,
                    crochet: n["crochet"] as? Bool,
                    name: n["name"] as? String
                    ))
            }
        }
        
        if let packs = p["packs"] as? NSArray {
            for pack in packs {
                var name: String?
                var company: String?
                var weightType: String?
                var wpi: String?
                var ply: String?
                var minGauge: String?
                var maxGauge: String?
                var knitGauge: String?
                var crochetGauge: String?
                
                
                
                if let yarn = pack["yarn"] as? NSDictionary {
                    var y = filterValues(yarn)
                    name = y["name"] as? String
                    company = y["yarn_company_name"] as? String
                }
                
                if let yarnWeight = pack["yarn_weight"] as? NSDictionary {
                    var y = filterValues(yarnWeight)
                    weightType = y["name"] as? String
                    wpi = y["wpi"] as? String
                    ply = y["ply"] as? String
                    minGauge = y["minGauge"] as? String
                    maxGauge = y["maxGauge"] as? String
                    knitGauge = y["knitGauge"] as? String
                    crochetGauge = y["crochetGauge"] as? String
                }
                
                
                pattern!.yarns.append(Yarn(
                    name: name,
                    company: company,
                    weightType: weightType,
                    wpi: wpi,
                    ply: ply,
                    minGauge: minGauge,
                    maxGauge: maxGauge,
                    knitGauge: knitGauge,
                    crochetGauge: crochetGauge
                    ))
                
            }
        }
        
        if let photos = p["photos"] as? NSArray {
            for photo in photos {
                 pattern!.photos.append(loadMipmap(photo as? NSDictionary))
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
    }
    
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        
        if remaining == total {
            ++mipmapsLoaded
            println("\(mipmapsLoaded) out of \(pattern?.photos.count) Mipmaps Loaded")
            if mipmapsLoaded == pattern?.photos.count {
                aDelegate!.loadComplete(self, action: "PatternLoaded")
            }
        }
    }
    
}