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

    func delete(entity: String, index: Int) -> Bool {
        var data = fetch(entity)
        if data != nil {
            managedContext.deleteObject(data![index])
            data!.removeAtIndex(index)
            managedContext.save(nil)
            return true
        }
        
        return false
    }
    
    func fetch(entity: String) -> [NSManagedObject]? {
        var request = NSFetchRequest(entityName: entity)
        var error: NSError?
        if let entities = managedContext.executeFetchRequest(
            request,
            error: &error
        ) as? [NSManagedObject] {

            if entities.count > 0 {
                return entities
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
            println("Fetched \(entity)")
            return result[0]
        } else {
            return nil
        }
    }
    
    func save(entity: String, _ attributes: [String: AnyObject]) -> NSManagedObject? {
        
        var entity = NSEntityDescription.entityForName(
            entity,
            inManagedObjectContext: self.managedContext
        )

        let object = NSManagedObject(
            entity: entity!,
            insertIntoManagedObjectContext: self.managedContext
        )
        
        for (key, attr) in attributes {
            println("\(entity), \(key) : \(attr)")
            object.setValue(attr, forKey: key)
        }
        
        var error: NSError?

        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return nil
        }
        
        return object
    }
}