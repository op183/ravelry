//
//  LoaderImageController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class LoaderImageController: UIViewController, OAuthServiceDelegate, OAuthServiceResultsDelegate, AsyncLoaderDelegate, MipmapLoaderDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        loadUser()
        ravelryCategories = CategoryParser<NSDictionary>()
            .loadData("categories")
            .getCategories()
    }
    
    func setProgress(remaining: Int, _ total: Int) {
        progressBar!.setProgress(Float(remaining / total), animated: false)
    }
    
    func getOAuthRequestToken() {
        mOAuthService.delegate = self
        mOAuthService.getRequestToken()
    }
    
    func createNewUser(accessToken: String, accessTokenSecret: String, username: String) {
        if let user = User.create([
            "access_token": accessToken,
            "access_token_secret": accessTokenSecret,
            "name": username
            ]) {
                loadUser(user)
        } else {
            println("Could not save")
        }
        
    }
    
    func setAccessToken(user: User) {
        if let accessToken = user.getAccessToken() {
            if let accessTokenSecret = user.getAccessTokenSecret() {
                if let username = user.getName() {
                    println("User Access Token ... \(accessToken)")
                    println("User Access Token Secret ... \(accessTokenSecret)")
                    println("User Name ... \(username)")
                    
                    mOAuthService.setAccessToken(
                        accessToken,
                        accessTokenSecret: accessTokenSecret,
                        username: username
                    )
                } else {
                    println("No username ... destroying user 0")
                    User.destroy(0);
                    loadUser()
                }
            } else {
                println("No access token secret ... destroying user 0")
                User.destroy(0);
                loadUser()
            }
        } else {
            println("No access token ... destroying user 0")
            User.destroy(0);
            loadUser()
        }
    }
    
    func accessTokenHasBeenFetched(accessToken: String, accessTokenSecret: String, username: String) {
        createNewUser(accessToken, accessTokenSecret: accessTokenSecret, username: username)
    }
    
    func accessTokenHasExpired() {
        getOAuthRequestToken()
    }
    
    func loadUser() {
        if let user = cdm!.first("User") as? User {
            loadUser(user)
        } else {
            println("No user discovered ... searching for request token.")
            getOAuthRequestToken()
        }
    }
    
    func loadUser(user: User) {
        ravelryUser = user
        setAccessToken(ravelryUser!)
        mOAuthService.getFavoritesList(self, action: "GetUserFavorites")
        mOAuthService.getProjects(self, action: "GetUserProjects")
        mOAuthService.getQueue(self, action: "GetUserQueue")
    }

    
    func resultsHaveBeenFetched(results: NSData!, action: String) {
        println("Loading \(action)")
        switch action {
        case "GetUserFavorites":
            FavoritesParser<NSDictionary>(
                mDelegate: self,
                aDelegate: self
            ).loadData(results)
        case "GetUserProjects":
            ProjectsParser<NSDictionary>(
                mDelegate: self,
                aDelegate: self
            ).loadData(results)
        case "GetUserQueue":
            QueueParser<NSDictionary>(
                mDelegate: self,
                aDelegate: self
            ).loadData(results)
        default:
            NSException(name: "UnpermittedAction", reason: "\(action) is not a permitted action", userInfo: nil).raise()
        }
    }
    
    func loadComplete(object: AnyObject, action: String) {
        
        switch action {
            case "FavoritesLoaded":
                //println("Favorites Loaded")
                favoritesHaveLoaded = true
                var parser = object as? FavoritesParser<NSDictionary>
                ravelryUser!.setFavorites(parser!.patterns)
            case "QueueLoaded":
                //println("Queue Loaded")
                queueHasLoaded = true
                var parser = object as? QueueParser<NSDictionary>
                var projects = parser!.projects
                println(projects)
                ravelryUser!.setQueue(projects)
            case "ProjectsLoaded":
                //println("Projects Loaded")
                projectsHaveLoaded = true
                var parser = object as? ProjectsParser<NSDictionary>
                var projects = parser!.projects
                println(projects)
                ravelryUser!.setProjects(projects)
            default:
                NSException(name: "UnpermittedAction", reason: "\(action) is not a permitted action", userInfo: nil).raise()
        }
        
        if projectsHaveLoaded && queueHasLoaded && favoritesHaveLoaded {
            performSegueWithIdentifier("loadMainNavigator", sender: self)
        }

    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        setProgress(remaining, total)
    }
    
    private
    var favoritesHaveLoaded = false
    var projectsHaveLoaded = false
    var queueHasLoaded = false
    var patternsHaveLoaded = false
    
}