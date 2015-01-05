//
//  XMLParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate {
    func parsingHasFinished()
}

class XMLParser: NSObject, NSXMLParserDelegate {
 
    var delegate: XMLParserDelegate?

    var aParsedDict = [Dictionary<String, String>]()
	var currentDict = Dictionary<String, String>()

    var currentEl = ""
	var foundChars = ""
    var inParentNode: Bool = false
    
    let cats: [String]
    let parent: String
    let node: String
    
    var level: Int = 0
    
    init(cats: [String], parent: String, node: String) {
        self.cats = cats
        self.parent = parent
        self.node = node
        super.init()
    }
    
    /**
    *	@rssURL	: URL to pull RSS feed from
    **/
    
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        
        let parser: NSXMLParser? = NSXMLParser(contentsOfURL: rssURL)
        parser?.delegate = self
        var doesParse: Bool? = parser?.parse()
    }

    func getTabs() -> String {
        var tabs: String = ""
        if level > 0 {
        	for tab in 0...level {
            	tabs += "\t"
        	}
        } else {
            inParentNode = false
        }
        return tabs
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]) {
        
        currentEl = elementName

        if currentEl == parent {
            inParentNode = true
        }
        
        if inParentNode {
            //println("\(getTabs())Starting Element: \(elementName)")
            for attr in attributeDict {
                //println("\(getTabs())\tAttribute \(attr)")
            }
            ++level
        }
        
    }
    
	func parser(parser: NSXMLParser, foundCharacters string: String!) {
        if inParentNode && contains(cats, currentEl) {
			foundChars += string
        }
	}

    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        currentDict[currentEl] = ""
        if !foundChars.isEmpty && inParentNode {
            var error: NSError?
            currentDict[currentEl] = foundChars.trim()
            //println("\(getTabs())Found Chars \(currentDict[currentEl])")
            foundChars = ""
        }

        if inParentNode {
            --level
            //println("\(getTabs())Ending Element: \(elementName)")
            
            if elementName == node {
                //println("Saving Node: \(node)")
                aParsedDict.append(currentDict)
                currentDict = Dictionary<String, String>()
            }
        }

    }

    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError!) {
        println(parseError.description)
    }
    
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError!) {
        println(validationError.description)
    }
    
    func parserDidStartDocument(parser: NSXMLParser!) {
        println("Parser Did Start")
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        println("Parsing has finished")
        delegate?.parsingHasFinished()
    }
    
    func parser(parser: NSXMLParser!, foundElementDeclarationWithName elementName: String!, model: String!) {
        println("foundElementDeclarationWithName \(elementName)")
    }

    func parser(parser: NSXMLParser!, foundAttributeDeclarationWithName attributeName: String!, forElement elementName: String!, type: String!, defaultValue: String!) {
        println("foundAttributeDeclarationWithName \(attributeName) : \(defaultValue)")
    }

    func parser(parser: NSXMLParser!, foundExternalEntityDeclarationWithName name: String!, publicID: String!, systemID: String!) {
        println("foundExternalEntityDeclarationWithName \(name)")
    }

    func parser(parser: NSXMLParser!, foundInternalEntityDeclarationWithName name: String!, value: String!) {
        println("foundInternalEntityDeclarationWithName \(name) : \(value)")
    }

    func parser(parser: NSXMLParser!, foundUnparsedEntityDeclarationWithName name: String!, publicID: String!, systemID: String!, notationName: String!) {
        println("foundUnparsedEntityDeclarationWithName \(name)")
    }

    func parser(parser: NSXMLParser!, foundNotationDeclarationWithName name: String!, publicID: String!, systemID: String!) {
        println("foundNotationDeclarationWithName \(name)")
    }
    
}