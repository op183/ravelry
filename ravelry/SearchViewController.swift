//
//  SecondViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SearchViewController:  BaseRavelryNavigationController, UISearchBarDelegate, UISearchDisplayDelegate, AsyncLoaderDelegate, MipmapLoaderDelegate, OAuthServiceResultsDelegate {
    
    var parser: PatternsParser<NSDictionary>?
    var bundle = NSDictionary()
    var loaderDelegate: AsyncLoaderDelegate?
    @IBOutlet weak var searchBar: UISearchBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var query = ""
        
        if searchBar.text != nil {
            query = searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        }

        var params: [String:String] = [
            "query": query,
            "page_size": "10"
        ]
        
        mOAuthService.getPatterns(params, delegate: self, action: "GetPatterns")
    }
    
    func resultsHaveBeenFetched(data: NSData!, action: String) {

        parser = PatternsParser<NSDictionary>(
            mDelegate: self,
            aDelegate: self
        )
        parser!.loadData(data)
    }

    func imageHasLoaded(remaining: Int, _ total: Int) {
        
    }

    func loadComplete(object: AnyObject, action: String) {
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
}

