//
//  ArticleContent.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/12/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class ArticleContent: UIViewController, NSURLConnectionDelegate {
    
    
    @IBOutlet weak var contentView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideWebContentView(true)
        
    }
    
    func setImages(images: [NSURL]?) {
        //println("Setting Images")
        if images != nil {
            for image in images! {
                let request = NSURLRequest(URL: image)
                let connection = NSURLConnection()
                //println("Retrieving \(image)")
                NSURLConnection(
                    request: request,
                    delegate: self,
                    startImmediately: true
                )
            }
        }
    }
    
    func setDescription(text: String?) {
        if text != nil && contentView != nil {
            contentView.text = text
        }
    }
    
    func setTitle(text: String?) {
        if text != nil && titleView != nil {
            titleView.text = text
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func hideWebContentView(hide: Bool) {
        //webToolbar.hidden = hide
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var image = UIImage(data: data)
        
        if image != nil {
            var imageView = UIImageView(image: image!)
            collectionView.addSubview(imageView)
        }
    }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println("Connection Received Response")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Connection Failed with Error")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("Connection finished loading")
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }

}
