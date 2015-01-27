//
//  User.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData


@objc class User: NSManagedObject {

    @NSManaged var email: String?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var access_token: String?
    @NSManaged var access_token_secret: String?
    @NSManaged var user_setting_id: NSManagedObject?

    var favorites = [Int: Pattern]()
    var library = [Int: Pattern]()
    var queue = [Int: Project]()
    var projects = [Int: Project]()
    
    var settings = [Setting]()
    
    class func create(attributes: [String: AnyObject]) -> User? {
        if let newUser: User = cdm!.save("User", attributes) as? User {            
            return newUser
        } else {
            return nil
        }
    }
    
    class func destroy(index: Int) -> Bool {
        return cdm!.delete("User", index: index)
    }
    
    func getAccessToken() -> String? {
        return access_token
    }

    func getName() -> String? {
        return name
    }

    func getAccessTokenSecret() -> String? {
        return access_token_secret
    }
    
    func setLibrary(patterns: [Pattern]) {
        for pattern in patterns {
            self.library[pattern.id] = pattern
        }
    }
    
    func setFavorites(patterns: [Pattern]) {
        for pattern in patterns {
            self.favorites[pattern.id] = pattern
        }
    }
    
    func setQueue(projects: [Project]) {
        for project in projects {
            self.queue[project.id] = project
        }
    }

    func setProjects(projects: [Project]) {
        for project in projects {
            self.projects[project.id] = project
        }
    }
    
    func addFavorite(pattern: Pattern, comment: String, tags: String, delegate: OAuthServiceResultsDelegate) {
        pattern.comment = comment
        pattern.setTags(tags)
        
        self.favorites[pattern.id] = pattern
        mOAuthService.favoritePattern(pattern.id,
            comment: comment,
            tags: tags,
            delegate: delegate,
            action: "FavoritePattern"
        )
    }
    
    func destroyFavorite(id: Int, delegate: OAuthServiceResultsDelegate) {
        var fav_id = self.favorites[id]!.favoriteId!
        self.favorites.removeValueForKey(id)
        mOAuthService.unfavorite(fav_id,
            delegate: delegate,
            action: "DestroyPattern"
        )
    }
    
    func hasFavorite(id: Int) -> Bool {
        return favorites[id] != nil
    }
    
    func getFavorites() -> [Pattern] {
        var patterns = [Pattern]()
        for (k, v) in self.favorites {
            patterns.append(v)
        }
        return patterns
    }

    func getProjects() -> [Project] {
        var projects = [Project]()
        
        println(self.projects)
        
        for (k, v) in self.projects {
            projects.append(v)
        }
        
        
        return projects
    }

    func getQueue() -> [Project] {
        var projects = [Project]()
        for (k, v) in self.queue {
            projects.append(v)
        }
        return projects
    }

}
