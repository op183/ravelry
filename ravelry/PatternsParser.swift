//
//  PatternsParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/28/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import Foundation

class PatternsParser<T>: RavelryJSONParser<T> {
    
    var patterns = [Pattern]()
    var loadAction = ActionResponse.PatternsRetrieved
    var numPatterns = 0
    
    override init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        super.parse(json)
        if let patterns = json["patterns"] as? NSArray {
            numPatterns += patterns.count
            for pattern in patterns {
                if let p = self.parsePatternResult((pattern as? NSDictionary)!) {
                    self.patterns.append(p) 
                }
            }
        }
        return self
    }
    
    override func checkProgress(remaining: Int, _ total: Int) {
        if remaining == total {
            ++patternsLoaded
            println("Pattern has loaded \(patternsLoaded) \\ \(numPatterns)")
            if numPatterns == patternsLoaded {
                aDelegate!.loadComplete(self, action: loadAction)
            }
        }
        
    }
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        checkProgress(remaining, total)
        //println("Image has loaded \(total) / \(remaining)")
    }

    private
    var patternsLoaded: Int = 0
}