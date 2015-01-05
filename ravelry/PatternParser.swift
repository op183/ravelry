//
//  PatternParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//


import UIKit

class PatternParser<T>: JSONParser<T> {

    var pattern: Pattern?
    
    init(delegate: AsyncLoaderDelegate, pattern: Pattern) {
        super.init(delegate: delegate)
        self.pattern = pattern
    }
    
    override func parse(json: NSDictionary) {
        if let p = json["pattern"] as? NSDictionary {
            
            pattern!.yarnWeight = p["yarn_weight_description"] as? String
            pattern!.yardageMax = p["yardage_max"] as? Float
            pattern!.gaugePattern = p["gauge_pattern"] as? String
            pattern!.notes = p["notes"] as? String
            pattern!.yardage = p["yardage_description"] as? String
            pattern!.gauge = p["gauge"] as? Float
            pattern!.gaugeDivisor = p["gauge_divisor"] as? Float
         
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
        }
        loaderDelegate!.loadComplete(self)
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
    
}