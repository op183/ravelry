//
//  QueryBuilder.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum CategoryType: String {
    case Category = "pc"
    case Attribute = "pa"
    case Weight = "weight"
    case Yardage = "yardage"
    case HookSize = "hooks"
    case NeedleSize = "needles"
}

class QueryBuilder {

    let separator = "|"
    var parameters = [CategoryType:[String]]()
    
    init() {
        
    }
    
    func addParameter(param: String, _ type: CategoryType) {

        if parameters[type] == nil {
            parameters[type] = [String]()
        }

        parameters[type]!.append(param)
    }
    
    func removeParameter(param: String, _ type: CategoryType) {
        if parameters[type] != nil {
            if let index = find(parameters[type]!, param) {
                parameters[type]!.removeAtIndex(index)
            }
        }
    }
    
    func build() -> String {
        var query: String = ""
        for (type, params) in parameters {
            query += "\(type)="
            var paramString = ""
            for param in params {
                paramString += "\(param)\(separator)"
            }
            paramString = paramString.rtrim(separator)
            query += "\(paramString.percentEncode())&"
        }
        return query.rtrim("&")
    }
    
}
