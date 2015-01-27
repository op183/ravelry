//
//  ProjectsParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ProjectsParser<T>: RavelryJSONParser<T> {
    
    var projects = [Project]()
    var projectsLoaded: Int = 0
    var numProjects = 0
    var loadAction = "ProjectsLoaded"
    
    override init(mDelegate: MipmapLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        if let projects = json["projects"] as? NSArray {
            numProjects = projects.count
            for project in projects {
                var id = project["id"] as Int
                var patternId = project["pattern_id"] as Int
                var name = project["name"] as? String
                var patternName = project["pattern_name"] as? String
                var craft = Craft(rawValue: (project["craft_id"] as? Int)!)

               self.projects.append(Project(
                    id: id,
                    patternId: patternId,
                    name: name!,
                    patternName: patternName!,
                    photo: loadMipmap(project["first_photo"] as? NSDictionary),
                    craft: craft!
                ))
                println("Parsing Projects")
                println(self.projects)
            }
        }
        
        return self
    }

    override func checkProgress(remaining: Int, _ total: Int) {
        if remaining == total {
            ++projectsLoaded
            if numProjects == projectsLoaded {
                aDelegate!.loadComplete(self, action: loadAction)
            }
        }
    }
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        checkProgress(remaining, total)
    }
}