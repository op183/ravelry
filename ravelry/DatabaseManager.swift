//
//  DatabaseManager.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/2/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    var db: FMDatabase?
    let path: String?
    
    class var instance: DatabaseManager {
        dbManager.db = FMDatabase(path: dbManager.path!)
        println(dbManager)
        return dbManager
    }

    init(databaseName: String) {
        var manager = NSFileManager.defaultManager()
        var error: NSError?

        if !fileManager.fileExistsAtPath(dbPath) {
            var fromPath: NSString = NSBundle.mainBundle().resourcePath.stringByAppendingPathComponent(fileName)
            fileManager.copyItemAtPath(fromPath, toPath: dbPath, error: nil)
        }
        
        path = manager.currentDirectoryPath
        println("Current Directory Path \(path)")

        var contents = manager.contentsOfDirectoryAtPath(".", error: &error)

        for content in contents! {
            println(content)
        }
        
        //let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //path = documentsFolder.stringByAppendingPathComponent(dbName)
    }

    func getColumnNames(table: String) -> [String] {
        db!.open()
        var resultSet: FMResultSet? = db!.executeQuery("PRAGMA table_info(\(table))", withArgumentsInArray: nil)
        println(resultSet)

        db!.close()

        //0|id|integer|0||1
        //1|name|varchar(255)|0||0
        //2|email|varchar(255)|0||0
        //3|password|varchar(255)|0||0
        return [String]()
    }
    
    func select(table: String, whereClause: String?) -> [[String:AnyObject]] {
        return select(table, whereClause: whereClause, limit: -1)
    }

    func select(table: String, whereClause: String?, limit: Int) -> [[String:AnyObject]] {
        var completeWhereClause = ""
        var results = [[String:AnyObject]]()
        var columns = getColumnNames(table)

        db!.open()
        
        if whereClause != nil {
            completeWhereClause = " WHERE \(whereClause)"
        }

        var resultSet: FMResultSet? = db!.executeQuery("SELECT FROM \(table)\(completeWhereClause) LIMIT \(limit)", withArgumentsInArray: nil)

        if resultSet != nil {
            while resultSet!.next() {
                var r = [String:AnyObject]()
                for column in columns {
                    r[column] = resultSet!.stringForColumn(column)
                }
                results.append(r)
            }
        }
        
        db!.close()
        return results
    }

    
    func first(table: String) -> [String:AnyObject] {
        var results: [[String: AnyObject]] = select(table, whereClause: nil, limit: 1)
        return results[0]
    }
    
    func insert(table: String, values: [String:AnyObject]) {
        
    }
    
    func update(table: String, values: [String:AnyObject]) {
        
    }
    
    func delete() {
        
    }
}