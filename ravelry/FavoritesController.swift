//
//  FavoritesController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/18/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class FavoritesController: BaseResultsController {
    
    override var patterns: [Pattern] {
        return ravelryUser!.getFavorites()
    }
    
    override var totalRecords: Int {
        return ravelryUser!.totalFavorites
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segueAction = "showFavoritePattern"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == patterns.count {
            if let cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as? ViewMoreCell {
                cell.selected = true
            }
            
            ravelryUser!.loadFavorites {
                println("Reloading Favorites")
                (self.view as UITableView).reloadData()
            }
        } else {
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as SearchResult
            selectedPatternIndex = indexPath.row
            showOverlay()
            mOAuthService.getPattern(patterns[selectedPatternIndex].id, delegate: self)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if patterns.count == indexPath.row {
            var cell = tableView.dequeueReusableCellWithIdentifier("viewMoreCell", forIndexPath: indexPath) as ViewMoreCell
            cell.selected = false
            return cell
        } else {
            let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as FavoriteCell
            let pattern = patterns[indexPath.row]
            cell.commentText.text = pattern.getComment()
            cell.imageView!.image = pattern.getThumbnail()
            return cell
        }
        
    }

    override func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .PatternRetrieved:
                PatternParser<NSDictionary>(
                    mDelegate: self,
                    aDelegate: self,
                    pattern: patterns[selectedPatternIndex]
                ).loadData(data)
            default:
                println("\(action) is not an acceptable action!")
        }
        
    }
    
    override func loadComplete(object: AnyObject?, action: ActionResponse) {
        switch action {
            case .PatternRetrieved:
                self.performSegueWithIdentifier(segueAction!, sender: self)
            default:
                println("\(action) is not an acceptable action!")
        }
    }
}
