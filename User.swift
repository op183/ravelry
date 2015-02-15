//
//  User.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData

typealias DataFetchAction = () -> ()

@objc class User: NSManagedObject, OAuthServiceResultsDelegate, PhotoSetLoaderDelegate, AsyncLoaderDelegate {

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
    var dataFetchQueue = [ActionResponse: DataFetchAction]()
    
    var totalProjects = 0
    var projectsPageCount = 2
    var totalFavorites = 0
    var favoritesPageCount = 2
    var totalQueuedProjects = 0
    var queuedProjectsPageCount = 2
    
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
            delegate: delegate
        )
    }
    
    func destroyFavorite(id: Int, delegate: OAuthServiceResultsDelegate) {
        var fav_id = self.favorites[id]!.favoriteId!
        self.favorites.removeValueForKey(id)
        mOAuthService.unfavorite(fav_id,
            delegate: delegate
        )
    }
    
    func hasFavorite(id: Int) -> Bool {
        return favorites[id] != nil
    }
    
    func hasProject(patternId: Int) -> Bool {
        return (findProjectByPatternId(patternId, projects) != nil) ? true : false
    }

    
    func hasProjectInQueue(patternId: Int) -> Bool {
        return (findProjectByPatternId(patternId, queue) != nil) ? true : false
    }
    
    func getProjectByPatternId(patternId: Int) -> Project? {
        return findProjectByPatternId(patternId, projects)
    }
    
    func getFavorites() -> [Pattern] {
        var patterns = [Pattern]()
        for (k, v) in self.favorites {
            patterns.append(v)
        }
        return patterns
    }

    func loadProjects(completion: DataFetchAction) {
        dataFetchQueue[.ProjectsRetrieved] = completion
        mOAuthService.getProjects(self, page: projectsPageCount++)
    }
    
    func loadQueue(completion: DataFetchAction) {
        dataFetchQueue[.QueueRetrieved] = completion
        mOAuthService.getQueue(self, page: queuedProjectsPageCount++)
    }
    
    func loadFavorites(completion: DataFetchAction) {
        dataFetchQueue[.FavoritesRetrieved] = completion
        mOAuthService.getFavoritesList(self, page: favoritesPageCount++)
    }
    
    
    func getProjects() -> [Project] {
        var projects = [Project]()
        
        //println(self.projects)
        
        for (k, v) in self.projects {
            projects.append(v)
        }
        
        
        return projects
    }
    
    func createProject(pattern: Pattern) {
        mOAuthService.createProjectFromPattern(pattern, delegate: self)
    }

    func addToQueue(id: Int) {
        mOAuthService.addToQueue(id, delegate: self)
    }
    
    func removeFromQueue(id: Int) {
        if let project = findProjectByPatternId(id, queue) {
            mOAuthService.removeFromQueue(project.id, delegate: self)
        }
    }

    func getQueue() -> [Project] {
        var projects = [Project]()
        for (k, v) in self.queue {
            projects.append(v)
        }
        return projects
    }

    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .ProjectsRetrieved:
                ProjectsParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
            case .QueueRetrieved:
                QueueParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
            case .FavoritesRetrieved:
                FavoritesParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
            case .PatternQueued:
                QueuedProjectParser<NSDictionary>(mDelegate: self, aDelegate: self).loadData(data)
            case .ProjectCreated:
                ProjectParser<NSDictionary>(mDelegate: self, aDelegate: self, project: Project()).loadData(data)
            case .ProjectDequeued:
                if let json = data.toJSON() {
                    if let project = json["queued_project"] as? NSDictionary {
                        if let id = project["id"] as? Int {
                            queue.removeValueForKey(id)
                        }
                    }
                }
            default:
                println("Action IS \(action.rawValue)")
        }
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
        if let parser = object as? ProjectsParser<NSDictionary> {

            for project in parser.projects {
                switch action {
                    case .QueueRetrieved:
                        queue[project.id] = project
                    default:
                        projects[project.id] = project

                }
            }
            
        }  else if let parser = object as? FavoritesParser<NSDictionary> {

            for pattern in parser.patterns {
                favorites[pattern.id] = pattern
            }
        
        } else if let parser = object as? QueuedProjectParser<NSDictionary> {
            if let project = parser.project {
                queue[project.id] = project
            }
        } else if let parser = object as? ProjectParser<NSDictionary> {
            let project = parser.project
            println("Adding Project \(project.id)")
            projects[project.id] = project
        } else {
            println("LoadComplete \(action)")
        }

        println(favorites)

        if let completionHandler = dataFetchQueue[action] {
            completionHandler()
        }

    }

    func imageHasLoaded(remaining: Int, _ total: Int) {}
    
    private func findProjectByPatternId(patternId: Int, _ projects: [Int: Project]) -> Project? {
        for (id, project) in projects {
            if project.patternId == patternId {
                return project
            }
        }
        
        return nil
    }
        
}
