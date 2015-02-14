//
//  FileCache.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/11/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum CacheDirectory: String {
    case Patterns = "patterns"
    case Projects = "projects"
}

class Directory {
    var location: NSURL
    var subdirectories = [String: Directory]()
    
    init(location: NSURL) {
        self.location = location
    }
    
    func getFilepath(name: String) -> NSURL {
        return NSURL(string: location.absoluteString!.stringByAppendingFormat("/%@", name))!
    }
    
    func addSubdirectory(name: String, _ subdir: Directory) -> Directory? {
        subdirectories.updateValue(subdir, forKey: name)
        return subdirectories[name]
    }
    
    func getSubdirectory(name: String) -> Directory? {
        return subdirectories[name]
    }
    
}

class FileCache: NSObject {
    
    let fileManager = NSFileManager.defaultManager()
    
    let cacheDir = Directory(
        location: NSURL(string: (NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String).stringByAppendingFormat("/fkcomp.ravelry.cache/"))!
    )
    
    override init() {
        super.init()

        var error: NSError?
        if let contents = fileManager.contentsOfDirectoryAtURL(
            cacheDir.location,
            includingPropertiesForKeys: nil,
            options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
            error: &error
        ) {
            for content in contents as [NSURL] {
                //println(content)
                if (isDirectory(content.absoluteString!)) {
                    if let matches = content.absoluteString!.match("/\\/(\\d+)\\/$/") {
                        cacheDir.addSubdirectory(
                            matches[0],
                            Directory(location: NSURL(string: content.absoluteString!)!)
                        )
                    }
                }
            }
        }
    }
    
    func makeDir(name: String, directory: Directory) -> Directory? {
        var error: NSError?
        var newDir = directory.getFilepath(name)
        if !fileManager.fileExistsAtPath(newDir.absoluteString!) {
            
            if fileManager.createDirectoryAtPath(
                newDir.absoluteString!,
                withIntermediateDirectories: true,
                attributes: nil,
                error: &error
            ) {
                
                var addDir = Directory(location: newDir)
                return directory.addSubdirectory(name, addDir)
                    
            } else {
                println(error)
                return nil
            }
            
        } else {
            return cacheDir.getSubdirectory(name)
        }
    }
    
    func fileExists(URL: NSURL) -> Bool {
        if !fileManager.fileExistsAtPath(URL.absoluteString!) {
            return false
        } else {
            return true
        }
    }
    
    func isDirectory(filepath: String) -> Bool {
        var isDirectory: ObjCBool = false
        if fileManager.fileExistsAtPath(filepath, isDirectory: &isDirectory) {
            return true
        }
        
        return false
    }
    
    func findInCache(id: String, name: String) -> NSURL? {
        if let directory = makeDir(id, directory: cacheDir) {
            var file = directory.getFilepath(name)
            if fileExists(file) {
                return file
            }
        }
        return nil
    }
    
    func putDataInCache(id: String, name: String, data: NSData) {
        if let subdir = cacheDir.getSubdirectory(id) {
            fileManager.createFileAtPath(
                subdir.getFilepath(name).absoluteString!,
                contents: data,
                attributes: nil
            )
        }
    }
    
    func getCacheSize() -> UInt64 {
        println("Fetching Cache Size \(cacheDir.location.absoluteString!)")
        return iterateRecursive(cacheDir.location.absoluteString!, fileSize: 0)
    }
    
    private func iterateRecursive(path: String, var fileSize: UInt64) -> UInt64 {
        var error: NSError?
        
        if let filesArray = self.fileManager.subpathsOfDirectoryAtPath(path, error: &error) as? [String] {
            for fileName in filesArray {
                let filepath = path.stringByAppendingPathComponent("/\(fileName)")
                if isDirectory(filepath) {
                    fileSize += iterateRecursive(filepath, fileSize: fileSize)
                } else {
                    var error: NSError?
                    let fileDictionary: NSDictionary = self.fileManager.attributesOfItemAtPath(filepath, error: &error)!
                    println(fileDictionary.fileSize())
                    fileSize += fileDictionary.fileSize()
                }
            }
        } else {
            println(error)
        }

        return fileSize
    }

    
    
}