//
//  ProjectParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class ProjectParser<T>: RavelryJSONParser<T>
{
    var project: Project
    var mipmapsLoaded: Int = 0
    init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate, project: Project) {
        self.project = project
        super.init(mDelegate: mDelegate, aDelegate: aDelegate)
    }
        
    override func parse(json: NSDictionary) -> JSONParser<T> {
        super.parse(json)
        if let p = json["project"] as? NSDictionary {
            parseProject(p)
        }
        return self
    }
    
    func parseProject(p: NSDictionary) {
        
        
        if let notes = p["notes"] as? String {
            project.notes = notes
        }
        
        if let packs = p["packs"] as? NSArray {
            for pack in packs {
                project.packs.append(parsePack(pack as NSDictionary))
            }
        }

        if let needles = p["needle_sizes"] as? NSArray {
            for needle in needles {
                project.needles.append(parseNeedleSize(needle as NSDictionary))
            }
        }
        
        if let rating = p["rating_count"] as? String {
            project.rating = rating
        }

        if let fav = p["favorites_count"] as? Int {
            project.favoritesCount = fav
        }
        if let com = p["comments_count"] as? Int {
            project.commentsCount = com
        }
        
        if let progress = p["progress"] as? Int {
            project.progress = progress
        }
 
        if let status = p["status"] as? Int {
            project.status = Status(rawValue: status)!
        }
        
        if let started = p["started"] as? String {
            if let startDate = started.toDate() {
                project.started = startDate
            }
        }
        
        if let completed = p["completed"] as? String {
            if let completeDate = completed.toDate() {
                project.completed = completeDate
            }
        }
        
        project.photos = parsePhotos(p["photos"] as? NSArray)
    }
    
    override func imageHasLoaded(remaining: Int, _ total: Int) {
        super.imageHasLoaded(remaining, total)
        println("Project Parse Image has Loaded")
        if remaining == total {
            
            if total > 0 {
                ++mipmapsLoaded
            }
            
            if mipmapsLoaded == project.photos.count {
                aDelegate!.loadComplete(self, action: .ProjectRetrieved)
            }
        }
    }
    
}