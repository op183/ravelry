//
//  QueuedProjectParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/9/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

//
//  ProjectParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class QueuedProjectParser<T>: RavelryJSONParser<T>
{
    var project: Project?
    var mipmapsLoaded: Int = 0

    override init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
    }
    
    override func parse(json: NSDictionary) -> JSONParser<T> {
        super.parse(json)
        if let p = json["queued_project"] as? NSDictionary {
            parseQueuedProject(p)
        }
        return self
    }
    
    
    func parseQueuedProject(p: NSDictionary) {
        project = Project(
            id: p["id"] as Int,
            patternId: p["pattern_id"] as Int,
            name: p["name"] as String,
            patternName: p["pattern_name"] as String,
            photo: loadMipmap(p["best_photo"] as? NSDictionary)
        )
        
        if let notes = p["notes"] as? String {
            project!.notes = notes
        }
        
    }
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        if remaining == total {
            
            if total > 0 {
                ++mipmapsLoaded
            }
            aDelegate!.loadComplete(self, action: .QueuedProjectRetrieved)
        }
    }
    
}