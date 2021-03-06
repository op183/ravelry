//
//  FavoritesParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/19/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class FavoritesParser<T>: PatternsParser<T> {
    
    override init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
        loadAction = .FavoritesRetrieved
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        super.parse(json)
        if let favorites = json["favorites"] as? NSArray {
            numPatterns = favorites.count

            if numPatterns == 0 {
                aDelegate!.loadComplete(self, action: loadAction)
            }
            
            for favorite in favorites {

                if let type = favorite["type"] as? String {
                    switch type {
                        case "pattern":
                            if let pattern = favorite["favorited"] as? NSDictionary {
                                if let p = self.parsePatternResult(pattern) {
                                    
                                    if let comment = favorite["comment"] as? String {
                                        p.comment = comment
                                    }

                                    p.favoriteId = favorite["id"] as? Int
                                    patterns.append(p)
                                }
                            }
                        default:
                            println("Favorite type is \(type)")
                    }
                }
                    
            }
        }
        return self
    }
}