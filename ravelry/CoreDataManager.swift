//
//  CoreDataManager.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/2/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let managedContext: NSManagedObjectContext
    
    init(context: AppDelegate) {
        self.managedContext = context.managedObjectContext!
    }

    func fetch(entity: String) -> [AnyObject]? {
        var request = NSFetchRequest(entityName: entity)
        var error: NSError?
        var results = managedContext.executeFetchRequest(
            request,
            error: &error
        ) as [NSManagedObject]?

        if let entities = results {
            if entities.count > 0 {
                return entities as [AnyObject]
            } else {
                println("Could Not Fetch \(entity)")
                return nil
            }
        }
        
        println("Could not fetch \(error), \(error!.userInfo)")
        return nil
    }
    
    func first(entity: String) -> AnyObject? {
        if let result = fetch(entity) {
            println("Fetched \(result[0])")
            return result[0]
        } else {
            return nil
        }
    }
    
    func insert(entity: String, attributes: [String: AnyObject]) -> NSObject? {
        var entity = NSEntityDescription.insertNewObjectForEntityForName(
            entity,
            inManagedObjectContext: self.managedContext
        ) as NSObject

        for (key, attr) in attributes {
            entity.setValue(attr, forKey: key)
        }
        
        var error: NSError?

        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return nil
        }
        
        return entity
    }
}