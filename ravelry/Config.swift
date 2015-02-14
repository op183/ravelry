//
//  Config.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//


import UIKit

let MAX_PATTERNS_PER_PAGE = 15
let MAX_PROJECTS_PER_PAGE = 5
let MAX_FAVORITES_PER_PAGE = 5

let API = [
    "user": "070C505B63E50C3BAD3D",
    "access_key": "070C505B63E50C3BAD3D",
    "consumer_key": "070C505B63E50C3BAD3D",
    "request_token_callback": "ravelry://com.fkcomp.ravelry",
    "password": "_jP_2lOVBjSsYtC36hYacGbpjohCtzr8HSdzJBE2",
    "personal_key": "_jP_2lOVBjSsYtC36hYacGbpjohCtzr8HSdzJBE2",
    "secret_key": "ap3PxaF4l20xYOLf5+NcgHy5mTi1/pVWkojgP7jg",
    "consumer_secret": "ap3PxaF4l20xYOLf5+NcgHy5mTi1/pVWkojgP7jg"
]

var fileCache: FileCache?
var ravelryCategories = [String:AnyObject]()

var cdm: CoreDataManager?

var basalFont: UIFont?
var headlineFont = [UIFont?]()

var ravelryUser: User?

let mOAuthService = RavelryOAuthService(
    consumerKey: API["consumer_key"]!,
    consumerSecret: API["consumer_secret"]!,
    personalKey: API["personal_key"]!,
    requestTokenCallback: API["request_token_callback"]!
)

let COLORS = [
    "lightBlue": UIColor(red: 184, green: 204, blue: 228, alpha: 1.0)
]