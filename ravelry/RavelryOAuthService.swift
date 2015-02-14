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
    
    var createProjectURL: NSURL {
        return NSURL(string: "\(baseAPIURL)/projects/\(username!)/create.json")!
    }

    var addToQueueURL: NSURL {
        return NSURL(string: "\(baseAPIURL)/people/\(username!)/queue/create.json")!
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
    
    var createPackURL: NSURL? {
        get {
            return NSURL(string: "\(baseAPIURL)/packs/create.json")
        }
    }
    
    func requestUploadToken(completion: OAuthResponseHandler) {

        post(
            NSURL(string: "\(baseAPIURL)/upload/request_token.json")!,
            handler: completion
        )
    }
    
    
    func uploadImage(token: String, filepath: UIImage, completion: OAuthResponseHandler) {
       let URL = NSURL(string: "\(baseAPIURL)/upload/image.json")!
        
        var params = [
            "upload_token": token,
            "access_key": self.consumerKey,
        ]
        
        var files = [
            "file0": filepath
        ]
        
        //let boundary = generateBoundaryString()
        let request = uploadImage(URL, method: "POST", params: params, images: files)
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            if let r = response as? NSHTTPURLResponse {
                let status = r.statusCode
                switch(status) {
                    case(200):
                        println("Completed: 200")
                        completion(data, response, error)
                    case(415):
                        println("415: Unsupported Media Type")
                        println("Error: \(error)")
                        println("Response: \(response)")
                    default:
                        println("Status: \(status)")
                        println("Error: \(error)")
                }
            } else {
                println("Nope")
                println(response)
                println(error)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func uploadImage(URL: NSURL, method: String, params: [String:AnyObject], images: [String:UIImage]) -> NSURLRequest {

        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        
        var postBody:NSMutableData = NSMutableData()
        var postData:String = String()
        var boundary:String = "------WebKitFormBoundary\(uniqueId)"
        
        let request = getRequest(URL, method: method)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
        
        if params.count > 0 {
            postData += "--\(boundary)\r\n"
            for (key, value : AnyObject) in params {
                postData += "--\(boundary)\r\n"
                postData += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                postData += "\(value)\r\n"
            }
        }
        
        for (filename, image) in images {

            let data = UIImageJPEGRepresentation(image, 1.0)!
            
            postData += "--\(boundary)\r\n"
            postData += "Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(Int(NSDate().timeIntervalSince1970*1000)).jpg\"\r\n"
            postData += "Content-Type: image/jpeg\r\n\r\n"
            
            println(postData)
            postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
            postBody.appendData(data)
            postData = String()
            postData += "\r\n"
        }

        postData += "\r\n--\(boundary)--\r\n"
        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)

        request.HTTPBody = NSData(data: postBody)
        return request
    }
    
    
    func getPattern(id: Int, delegate: OAuthServiceResultsDelegate) {
        sendBasicRequest(NSURL(string: "\(baseAPIURL)/patterns/\(id).json")!, delegate: delegate, action: .PatternRetrieved)
    }

    func getPatterns(params: [String:AnyObject], delegate: OAuthServiceResultsDelegate) {
        var URL: NSURL = OAuthService.buildURL("\(baseAPIURL)/patterns/search.json", params: params)!
        println(URL)
        sendBasicRequest(URL, delegate: delegate, action: .PatternsRetrieved)
    }
    
    func getProjects(delegate: OAuthServiceResultsDelegate, page: Int = 1, pageSize: Int = MAX_PROJECTS_PER_PAGE) {
        post(
            self.projectsListURL!,
            params: ["page_size": pageSize, "page": page],
            delegate: delegate,
            action: .ProjectsRetrieved
        )
    }
    
    func getProject(id: Int, delegate: OAuthServiceResultsDelegate) {
        post(
            NSURL(string: "\(baseAPIURL)/projects/\(username!)/\(id).json")!,
            params: [String:String](),
            delegate: delegate,
            action: .ProjectRetrieved
        )
    }
    
    func getQueue(delegate: OAuthServiceResultsDelegate, page: Int = 1, pageSize: Int = MAX_PROJECTS_PER_PAGE) {
        post(
            self.queueURL!,
            params: ["page_size": pageSize, "page": page],
            delegate: delegate,
            action: .QueueRetrieved
        )
    }
    
    
    func favoritePattern(patternId: Int, comment: String, tags: String, delegate: OAuthServiceResultsDelegate) {
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
            action: .PatternFavorited
        )
        
    }
    
    func getFavoritesList(delegate: OAuthServiceResultsDelegate, page: Int = 1, types: [String] = ["Pattern"], pageSize: Int = MAX_FAVORITES_PER_PAGE) {
        
        get(
            self.favoritesListURL!,
            params: ["page_size": pageSize, "page": page, "type": types.implode("+")],
            delegate: delegate,
            action: .FavoritesRetrieved
        )
    }
    
    func unfavorite(id: Int, delegate: OAuthServiceResultsDelegate) {
        destroy(
            NSURL(string: "\(baseUserURL)/favorites/\(id).json")!,
            params: [String:String](),
            delegate: delegate,
            action: .PatternUnfavorited
        )
    }
    
    func deletePack(id: Int, delegate: OAuthServiceResultsDelegate) {
        destroy(
            NSURL(string: "\(baseAPIURL)/packs/\(id).json")!,
            delegate: delegate
        )
    }

    func updatePack(id: Int, data: [String:AnyObject], delegate: OAuthServiceResultsDelegate, action: String) {

        var params: [String:AnyObject] =  data + ["weight_units": "ounces"]
        var URL = NSURL(string: "\(baseAPIURL)/packs/\(id).json")!

        println(params)
        
        post(URL, json: OAuthService.jsonStringify(params)!, delegate: delegate, action: .PackUpdated)
        
    }
    
    func createPack(project: Project, data: [String: AnyObject], delegate: OAuthServiceResultsDelegate) {

        let params: [String:AnyObject] = data + [
            "length_units": "yards",
            "weight_units": "ounces",
            "project_id": project.id
        ]
        
        println(params)
        
        post(createPackURL!, json: OAuthService.jsonStringify(params)!, delegate: delegate, action: .PackCreated)
    }
    
    func createProjectFromPattern(pattern: Pattern, delegate: OAuthServiceResultsDelegate) {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        post(
            createProjectURL,
            params: [
                "pattern_id": pattern.id,
                "pattern_name": pattern.name,
                "craft_id": Craft.Knitting.id,
                "status": Status.InProgress.id,
                "started": dateFormatter.stringFromDate(todaysDate)
            ],
            delegate: delegate,
            action: .ProjectCreated
        )
    }

    func addToQueue(patternId: Int, delegate: OAuthServiceResultsDelegate) {
        post(
            addToQueueURL,
            params: [
                "pattern_id": patternId
            ],
            delegate: delegate,
            action: .PatternQueued
        )
    }

    func removeFromQueue(queuedProjectId: Int, delegate: OAuthServiceResultsDelegate) {
        let URL = NSURL(string: "\(baseAPIURL)/people/\(username!)/queue/\(queuedProjectId).json")!
        println(URL)
        destroy(URL,
            delegate: delegate,
            action: .ProjectDequeued
        )
    }
    
    func createProjectPhoto(project: Project, filepath: UIImage, delegate: OAuthServiceResultsDelegate) {
        var url = NSURL(string: "\(baseAPIURL)/projects/\(username!)/\(project.id)/create_photo.json")!
        
        requestUploadToken { (data, response, error) in
            println("Request Token Upload")
            if let json = data.toJSON() {
                if let token = json["upload_token"] as? String {
                    println("Request Token Returned: \(token)")
                    self.uploadImage(token, filepath: filepath) { (data, response, error) in
                        if let morejson = data.toJSON() {
                            if let uploads = morejson["uploads"] as? NSDictionary {
                                if let file0 = uploads["file0"] as? NSDictionary {
                                    if let imageId = file0["image_id"] as? Int {
                                        println("Image ID Returned: \(imageId)")
                                        self.post(
                                            url,
                                            params: ["image_id": imageId],
                                            delegate: delegate,
                                            action: .ProjectPhotoCreated
                                        )
                                    }
                                }
                            }
                        } else {
                            println("Data is null")
                        }
                    }
                }
            }
        }
    }

    func saveProject(project: Project, delegate: OAuthServiceResultsDelegate) {
        var needles = [Int]()
        var tags = [String]()

        for needle in project.needles {
            needles.append(needle.id)
        }

        for tag in project.tags {
            tags.append(tag)
        }

        let data: [String:AnyObject] = [
            //"completed": project.completed.description,
            "craft_id": project.craft.id,
            "name": project.name,
            "needle_sizes": needles,
            "notes": project.notes,
            "progress": project.progress,
            "project_status_id": project.status.id,
            "rating": project.rating,
            "size": project.size,
            //"started_date": project.started.description,
            "tag_names": tags
        ]
        
        var error: NSError?
        
        post(NSURL(string: "\(baseAPIURL)/projects/\(username!)/\(project.id).json")!,
            json: OAuthService.jsonStringify(data)!,
            delegate: delegate,
            action: .ProjectSaved
        )
    }
    
    func destroyProject(projectId: Int, delegate: OAuthServiceResultsDelegate) {
        
        destroy(
            NSURL(string: "\(baseAPIURL)/projects/\(username!)/\(projectId).json")!,
            delegate: delegate,
            action: .ProjectDestroyed
        )
    }
}
