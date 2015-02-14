//
//  CategoryCollectionController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/26/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryCollectionController: BaseRavelryCollectionViewController, OAuthServiceResultsDelegate, AsyncLoaderDelegate, PhotoSetLoaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var patternsParser: PatternsParser<NSDictionary>?
    var selectedPatternId: Int?
    var footer: CategoryCollectionViewFooter?

    var isLoadingPatterns: Bool = false
    var pageCount: Int = 2
    var queryParams = [String:String]();

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        patternsParser = PatternsParser<NSDictionary>(mDelegate: self, aDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .PatternRetrieved:
                PatternParser<NSDictionary>(mDelegate: self, aDelegate: self, pattern: patternsParser!.patterns[selectedPatternId!]).loadData(data)
            case .AdditionalPatternsRetrieved:
                println("View more Patterns")
                patternsParser!.loadAction = action
                patternsParser!.loadData(data)
            default:
                println("View Patterns")
                patternsParser!.loadAction = action
                patternsParser!.loadData(data)
        }
    }
    
    func loadComplete(object: AnyObject, action: ActionResponse) {
        switch action {
            case .PatternRetrieved:
                var parser = object as PatternParser<NSDictionary>
                patternsParser!.patterns[selectedPatternId!] = parser.pattern!
                hideOverlay()
                performSegueWithIdentifier("showCategorySearchPattern", sender: self)
            case .AdditionalPatternsRetrieved:
                println("More Patterns Loaded")
                ++pageCount
                hideLoader()
                collectionView!.reloadData()
            default:
                println("Default Action")
                ++pageCount
                hideLoader()
                collectionView!.reloadData()
        }
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPatternId = indexPath.row
        var pattern = patternsParser!.patterns[selectedPatternId!]
        mOAuthService.getPattern(pattern.id, delegate: self)
        showOverlay()
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        footer = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: "categoryCollectionFooter",
            forIndexPath: indexPath
        ) as? CategoryCollectionViewFooter
        
        footer!.viewMoreButton.addTarget(
            self,
            action: Selector("viewMoreAction:"),
            forControlEvents: .TouchDown
        )

        
        if isLoadingPatterns {
            showLoader()
        }
            
        return footer!
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return patternsParser!.patterns.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "categoryPatternView",
            forIndexPath: indexPath
            ) as? CategoryCollectionViewCell
        
        var index = indexPath.row
        cell!.image.image = patternsParser!.patterns[index].getThumbnail()
        
        return cell!
    }

    @IBAction func viewMoreAction(sender: UIButton!) {
        showLoader()
        //println("Get More Patterns(p. \(pageCount)) ")

        var params = queryParams
        params["page_size"] = "15"
        params["page"] = "\(pageCount)"

        mOAuthService.getPatterns(
            params,
            delegate: self
        )
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PatternViewController {
            vc.pattern = patternsParser!.patterns[selectedPatternId!]
        }
    }
    
    func setPatterns(patterns: [Pattern]) {
        patternsParser!.patterns = patterns
    }
    
    func showLoader() {
        isLoadingPatterns = true
        if footer != nil {
            footer!.loadingMore.startAnimating()
            footer!.viewMoreButton.hidden = true
        }
    }
    
    func hideLoader() {
        isLoadingPatterns = false
        if footer != nil {
            footer!.loadingMore.stopAnimating()
            footer!.viewMoreButton.hidden = false
        }
    }
}