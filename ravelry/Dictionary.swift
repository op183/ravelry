//
//  Dictionary.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/19/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

func +<T, E>(left: [T: E], right: [T: E]) -> [T: E] {
    var d = [T: E]()
    for (k, v) in left {
        d[k] = v
    }
    
    for (k, v) in right {
        d[k] = v
    }

    return d
}

func +=<T, E>(left: [T: E], right: [T: E]) -> [T: E] {
    return left + right
}

extension String {
    
    func repeat(times: Int) -> String {
        
        var rstring = ""
        if times > 0 {
            for i in 0...times {
                rstring = "\(rstring)\(self)"
            }
        }
        return rstring
    }
    
}

extension Dictionary {
    
    func toJSON(_ tabs: Int = 0) -> String {
        var json = "{"
        
        for (key, value) in self {
            if let v = value as? Dictionary {
                var j = v.toJSON(tabs + 1)
                json += "\\\"\(key)\\\": \(j),"
            } else if let v = value as? [AnyObject] {
                var j = v.toJSON(tabs + 1)
                json += "\\\"\(key)\\\": \(j),"
            } else if let v = value as? String {
                json += "\\\"\(key)\\\": \\\"\(v)\\\","
            } else if let v = value as? Int {
                json += "\\\"\(key)\\\": \(v),"
            } else if let v = value as? Double {
                json += "\\\"\(key)\\\": \(v),"
            }
        }
        json = json.rtrim(",")
        return "\(json)}"
    }
    
}

extension Array {
    
    func toJSON(_ tabs: Int = 0) -> String {
        var json = "["
        
        for value in self {
            if let v = value as? Dictionary<String,Any> {
                var j = v.toJSON(tabs + 1)
                json += "\(j),"
            } else if let v = value as? [AnyObject] {
                var j = v.toJSON(tabs + 1)
                json += "\(j),"
            } else if let v = value as? String {
                json += "\\\"\(v)\\\","
            } else if let v = value as? Int {
                json += "\(v),"
            } else if let v = value as? Double {
                json += "\(v),"
            }
        }
        
        json = json.rtrim(",")
        return "\(json)]"
    }
    
    
    func implode(delimiter: String) -> String {
        var string = ""
        
        for part in self {
            string += "\(part)\(delimiter)"
        }
        
        return string.rtrim(delimiter)
    }
    
    mutating func pop() -> T {
        return self.removeLast()
    }
    
    mutating func shift() -> T {
        return self.removeAtIndex(0)
    }
}
