//
//  XMLParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class XMLParser: NSObject, NSXMLParserDelegate {

	var arrParsedData = [Dictionary<String, String>]()
	var currentDataDictionary = Dictionary<String, String>()
	var currentElement = ""
	var foundCharacters = ""

	/**
	*	@rssURL	: URL to pull RSS feed from
	**/
	func startParsingWithContentsOfURL(rssURL: NSURL) {
		let parser = NSXMLParser(contentsOfURL: rssURL)
		parser?.delegate = self
		parser?.parse
	}

	
	func parser(parser: NSXMLParser, foundCharacters string: String!) {
		if (currentElement == "title" && currentElement != "Appcoda") || currentElement == "link" || currentElement == "pubDate"{
			foundCharacters += string
		}
	}
	
	
}