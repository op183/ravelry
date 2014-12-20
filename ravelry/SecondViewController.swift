//
//  SecondViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {
	
    var parser: JSONParser?
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        parser = JSONParser()
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        var query = "cowl"
        
        if searchBar.text != nil {
            query = searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        }
        
        var url = NSURL(
            scheme: "https",
            host: "api.ravelry.com",
            path: "/patterns/search.json?page_size=10&query=\(query)"
            )!
        
        println("URL: \(url)")
        parser!.parse(url)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

