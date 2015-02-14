//
//  QueueParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/22/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class QueueParser<T>: ProjectsParser<T> {


    override init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
        loadAction = .QueueRetrieved
    }
    
    override func parse(json: NSDictionary) -> JSONParser<T> {
        
        if let projects = json["queued_projects"] as? NSArray {
            super.parse(json)
            numProjects = projects.count
            for project in projects {
                var id = project["id"] as Int
                var patternId = project["pattern_id"] as Int
                var name = project["name"] as String
                var patternName = project["pattern_name"] as String
                
                self.projects.append(Project(
                    id: id,
                    patternId: patternId,
                    name: name,
                    patternName: patternName,
                    photo: loadMipmap(project["best_photo"] as? NSDictionary, maxToLoad: 1)
                ))
            }
        }
        return self
    }
}