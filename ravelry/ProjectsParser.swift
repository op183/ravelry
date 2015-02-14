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
    var loadAction = ActionResponse.ProjectsRetrieved
    
    override init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        super.parse(json)
        if let projects = json["projects"] as? NSArray {
            numProjects = projects.count
            for project in projects {
                var id = project["id"] as Int

                var patternId = 0
                if let pid = project["pattern_id"] as? Int {
                    patternId = pid
                }
                
                var name = ""
                if let projectName = project["name"] as? String {
                    name = projectName
                }
                
                
                var patternName = ""
                if let pname =  project["pattern_name"] as? String {
                    patternName = pname
                }

                var craft: Craft?
                if let craftName = project["craft_id"] as? Int {
                    var craft = Craft(rawValue: craftName)
                }

                self.projects.append(Project(
                    id: id,
                    patternId: patternId,
                    name: name,
                    patternName: patternName,
                    photo: loadMipmap(project["first_photo"] as? NSDictionary, maxToLoad: 1),
                    craft: craft
                ))
            }
        }
        
        return self
    }

    override func checkProgress(remaining: Int, _ total: Int) {
        if remaining == total {
            ++projectsLoaded
            println("Project has loaded \(projectsLoaded) \\ \(numProjects)")
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