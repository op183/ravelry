//
//  ArticleContent.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/12/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class ArticleContent: UIViewController {

    var url: NSURL?
    var text: String?
    var images: [String]?
    
	@IBAction func showPublishDate(sender: AnyObject) {
	
	}
	
	@IBOutlet weak var webPublishDate: UIBarButtonItem!

	@IBOutlet weak var webToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideWebContentView(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if url != nil {
            let request: NSURLRequest = NSURLRequest(URL: url!)
        }
    }

    func hideWebContentView(hide: Bool) {
        webToolbar.hidden = hide
    }
}
