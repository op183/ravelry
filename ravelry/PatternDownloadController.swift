//
//  PatternDownloadController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/21/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class PatternDownloadController: BaseRavelryNavigationController {

    var link: NSURL?
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if link != nil {
            self.webView.loadRequest(NSURLRequest(URL: link!))
        }
    }
    
}