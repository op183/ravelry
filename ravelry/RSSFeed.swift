//
//  RSSFeed.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/12/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class RSSFeed: UITableViewController, XMLParserDelegate {

    var xmlParser: RavelryXMLParser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://www.ravelry.com/projects/klakitties.rss")
        xmlParser = RavelryXMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Number of Rows: \(xmlParser.aParsedDict.count)")
        return xmlParser.aParsedDict.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell

        let currentDict = xmlParser.aParsedDict[indexPath.row] as Dictionary<String, String>
    
        cell.textLabel.text = currentDict["title"]
 
        println("Table Cell Text: \(cell.textLabel.text)")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dictionary = xmlParser.aParsedDict[indexPath.row] as Dictionary<String, String>
        let link = dictionary["link"]
        
        
        let contentController = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewControllerWithIdentifier(
            "idArticleContent"
        ) as ArticleContent
        
        //contentController.url = NSURL(string: link!)!
        xmlParser.parseDescription(dictionary.description)
        
        contentController.setTitle(dictionary["title"])

        contentController.setDescription(xmlParser.fields["description"])
        contentController.setImages(xmlParser.images)
        
        showDetailViewController(contentController, sender: self)
        
    }
    
    func parsingHasFinished() {
        self.tableView.reloadData()
    }

}
