//
//  CategoryCollectionController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/26/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class CategoryCollectionController: BaseRavelryCollectionViewController, OAuthServiceResultsDelegate, AsyncLoaderDelegate, MipmapLoaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var patterns = [Pattern]()
    
    override func viewDidLoad() {
        mOAuthService.getPatterns(["page_size": "15"], delegate: self, action: "GetPatterns")
    }

    func resultsHaveBeenFetched(results: NSData!, action: String) {
        PatternsParser<NSDictionary>(mDelegate: self, aDelegate: self).loadData(results)
    }
    
    func loadComplete(object: AnyObject, action: String) {
        var parser = object as PatternsParser<NSDictionary>
        self.patterns = parser.patterns
        collectionView!.reloadData()
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return patterns.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "categoryPatternView",
            forIndexPath: indexPath
        ) as? CategoryCollectionViewCell
        
        var index = indexPath.row
        cell!.image.image = patterns[index].getThumbnail()
        
        return cell!
    }

    
    
}