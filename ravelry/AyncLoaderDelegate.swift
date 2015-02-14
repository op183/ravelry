//
//  AyncLoaderDelegate.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/19/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

enum ActionResponse: String {
    case ProjectCreated = "onProjectCreated:"
    case ProjectQueued = "onProjectQueued:"
    case ProjectSaved = "onProjectSaved:"
    case ProjectDestroyed = "onProjectDestroyed:"
    case ProjectsRetrieved = "onProjectsRetrieved:"
    
    case PatternFavorited = "onPatternFavorited:"
    case PatternUnfavorited = "onPatternUnfavorited:"
    case PatternsRetrieved = "onPatternsRetrieved:"
    case PatternRetrieved = "onPatternRetrieved:"
    
    case QueueRetrieved = "onQueueRetrieved:"
    case QueuedProjectRetrieved = "onQueuedProjectRetrieved:"
    
    case FavoritesRetrieved = "onFavoritesRetrieved:"
    case PackUpdated = "onPackUpdated:"

    case PatternQueued = "onPatternQueued:"
    case ProjectDequeued = "onProjectDequeued:"
    case PackCreated = "onPackCreated:"
    case ProjectRetrieved = "onProjectRetrieved:"
    case ProjectPhotoCreated = "onProjectPhotoCreated:"
    
    case PackDestroyed = "onPackDestroyed:"
    case AdditionalPatternsRetrieved = "onAdditionalPatternsRetrieved:"
    case Default = "onActionCompleted:"
    
    var selector: Selector {
        return Selector(self.rawValue)
    }
}

protocol AsyncLoaderDelegate {
    func loadComplete(object: AnyObject, action: ActionResponse)
}