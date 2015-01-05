//
//  SecondViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SearchViewController:  BaseRavelryNavigationController, UISearchBarDelegate, UISearchDisplayDelegate, AsyncLoaderDelegate {
	
    var parser: SearchResultsParser<NSDictionary>?
    var bundle = NSDictionary()
    var loaderDelegate: AsyncLoaderDelegate?
    @IBOutlet weak var searchBar: UISearchBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        parser = SearchResultsParser<NSDictionary>()
        parser!.loaderDelegate = self
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var query = ""
        
        if searchBar.text != nil {
            query = searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        }
        
        
        
        var url = NSURL(
            scheme: "https",
            host: "api.ravelry.com",
            path: "/patterns/search.json?page_size=10&query=\(query)"
        )!
        
        //println("URL: \(url)")
        parser!.parse(
            url,
            username: API["user"]!,
            password: API["password"]!
        )
    }
    
    func loadComplete(object: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        performSegueWithIdentifier("showSearchResults", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as SearchResultsController
        destinationVC.patterns = parser!.patterns
        if searchBar.text != nil {
            destinationVC.searchString = searchBar.text
        }
    }

    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

