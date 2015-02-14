//
//  LoaderImageController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class LoaderImageController: UIViewController, OAuthServiceDelegate, OAuthServiceResultsDelegate, AsyncLoaderDelegate, PhotoSetLoaderDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var firstPatterns = [Pattern]()

    lazy var progressBarQueue: NSOperationQueue = {
        var queue = NSOperationQueue.mainQueue()
        queue.name = "ProgressBarQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    override func viewDidLoad() {
        fileCache = FileCache()
        fileCache!.getCacheSize()
        loadUser()
        ravelryCategories = CategoryParser<NSDictionary>()
            .loadData("categories")
            .getCategories()
    }
    
    
    func setProgress(remaining: Int, _ total: Int) {
        progressBarQueue.addOperationWithBlock {
            let progress = Float(remaining) / Float(total)
            self.progressBar!.setProgress(progress, animated: true)
        }
        
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
                    //println("User Name ... \(username)")
                    
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
        mOAuthService.getFavoritesList(self)
        mOAuthService.getProjects(self)
        mOAuthService.getQueue(self)
        mOAuthService.getPatterns(["page_size": MAX_PATTERNS_PER_PAGE], delegate: self)
    }

    
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .PatternsRetrieved:
                PatternsParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
            case .FavoritesRetrieved:
                FavoritesParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self
                ).loadData(data)
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
            default:
                NSException(name: "UnpermittedAction", reason: "\(action.rawValue) is not a permitted action", userInfo: nil).raise()
        }
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
        
        switch action {
            case .PatternsRetrieved:
                patternsHaveLoaded = true
                var parser = object as? PatternsParser<NSDictionary>
                firstPatterns = parser!.patterns
            case .FavoritesRetrieved:
                favoritesHaveLoaded = true
                if let parser = object as? FavoritesParser<NSDictionary> {
                    ravelryUser!.totalFavorites = parser.totalRecords
                    ravelryUser!.setFavorites(parser.patterns)
                }
            case .QueueRetrieved:
                //println("Queue Loaded")
                queueHasLoaded = true
                if let parser = object as? QueueParser<NSDictionary> {
                    var projects = parser.projects
                    ravelryUser!.totalQueuedProjects = parser.totalRecords
                    ravelryUser!.setQueue(projects)
                }
            case .ProjectsRetrieved:
                projectsHaveLoaded = true
                if let parser = object as? ProjectsParser<NSDictionary> {
                    var projects = parser.projects
                    //println("Projects Loaded \(projects)")
                    ravelryUser!.totalProjects = parser.totalRecords
                    ravelryUser!.setProjects(projects)
                }
            default:
                NSException(name: "UnpermittedAction", reason: "\(action) is not a permitted action", userInfo: nil).raise()
        }
        
        if projectsHaveLoaded && queueHasLoaded && favoritesHaveLoaded && patternsHaveLoaded {
            performSegueWithIdentifier("loadMainNavigator", sender: self)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabController = segue.destinationViewController as UITabBarController
        
        
        if let splitViewController = tabController.viewControllers![0] as? UISplitViewController {
            if let navController = splitViewController.viewControllers[1] as? UINavigationController {
                if let searchController = navController.viewControllers[0] as? CategoryCollectionController {
                    //println("Setting Patterns for Category Collection Controller")
                    let searchButton = UIBarButtonItem(
                        image: UIImage(named: "magnifying-glass"),
                        style: UIBarButtonItemStyle.Plain,
                        target: splitViewController.displayModeButtonItem().target,
                        action: splitViewController.displayModeButtonItem().action
                    )
                    
                    //collectionController.navigationItem.leftBarButtonItem = searchButton
                    searchController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()

                    searchController.setPatterns(firstPatterns)
                }
            }
        }
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        setProgress(++totalRemaining, MAX_PATTERNS_PER_PAGE + (MAX_PROJECTS_PER_PAGE * 3))
    }
    
    private
    var totalRemaining = 0
    var favoritesHaveLoaded = false
    var projectsHaveLoaded = false
    var queueHasLoaded = false
    var patternsHaveLoaded = false
    
}