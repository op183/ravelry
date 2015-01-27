//
//  RavelryOAuthService.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/18/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class RavelryOAuthService: OAuthService {
    
    let baseURL: String = "https://www.ravelry.com"
    let baseAPIURL: String = "https://api.ravelry.com"
    
    override var requestTokenURL: NSURL? {
        get {
            return NSURL(string: "\(baseURL)/oauth/request_token")
        }
    }
    
    override var accessTokenURL: NSURL? {
        get {
            return NSURL(string: "\(baseURL)/oauth/access_token")
        }
    }
    
    override var authorizeURL: NSURL? {
        get {
            return NSURL(string: "\(baseURL)/oauth/authorize")
        }
    }
    
    var baseUserURL: String {
        get {
            return "\(baseAPIURL)/people/\(username!)"
        }
    }
    
    var favoritesURL: NSURL? {
        get {
            return NSURL(string: "\(baseUserURL)/favorites/create.json")
        }
    }
    
    var favoritesListURL: NSURL? {
        get {
            return NSURL(string: "\(baseUserURL)/favorites/list.json")
        }
    }
    
    var projectsListURL: NSURL? {
        get {
            return NSURL(string: "\(baseAPIURL)/projects/\(username!)/list.json")
        }
    }

    var queueURL: NSURL? {
        get {
            return NSURL(string: "\(baseUserURL)/queue/list.json")
        }
    }

    
    
    func getPattern(id: Int, delegate: OAuthServiceResultsDelegate, action: String) {
        sendBasicRequest(NSURL(string: "\(baseAPIURL)/patterns/\(id).json")!, delegate: delegate, action: action)
    }

    func getPatterns(params: [String:String], delegate: OAuthServiceResultsDelegate, action: String) {
        var URL: NSURL = OAuthService.buildURL("\(baseAPIURL)/patterns/search.json", params: params)!
        sendBasicRequest(URL, delegate: delegate, action: action)
    }

    func getProjects(delegate: OAuthServiceResultsDelegate, action: String) {
        post(
            self.projectsListURL!,
            params: [String:String](),
            delegate: delegate,
            action: action
        )
    }
    
    func getQueue(delegate: OAuthServiceResultsDelegate, action: String) {
        post(
            self.queueURL!,
            params: [String:String](),
            delegate: delegate,
            action: action
        )
    }
    
    
    func favoritePattern(patternId: Int, comment: String, tags: String, delegate: OAuthServiceResultsDelegate, action: String) {
        var params: [String: String] = [
            "comment": comment,
            "favorited_id": String(format: "%d", patternId),
            "tag_list": tags,
            "type": "pattern"
        ]
        
        post(
            self.favoritesURL!,
            params: params,
            delegate: delegate,
            action: action
        )
        
    }
    
    func getFavoritesList(delegate: OAuthServiceResultsDelegate, action: String) {
        get(
            self.favoritesListURL!,
            params: [String:String](),
            delegate: delegate,
            action: action
        )
    }
    
    func unfavorite(id: Int, delegate: OAuthServiceResultsDelegate, action: String) {
        destroy(
            NSURL(string: "\(baseUserURL)/favorites/\(id).json")!,
            params: [String:String](),
            delegate: delegate,
            action: action
        )
    }
    
    private
    
    func sendBasicRequest(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: String) {
        var request = getBasicAuthorizationRequest(URL)
        
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: NSOperationQueue.mainQueue()
            ) { (response, data, error) in
                if data != nil {
                    delegate.resultsHaveBeenFetched(data, action: action)
                } else {
                    println("No data returned from server: \(error)")
                }
        }
    }
    
    func getBasicAuthorizationRequest(URL: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: URL)
        let encodedAuth = "Basic " + "\(consumerKey):\(personalKey)".base64;
        request.addValue(encodedAuth, forHTTPHeaderField: "Authorization")
        return request
    }
}
