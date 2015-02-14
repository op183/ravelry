//
//  QueryBuilder.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/25/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class QueryBuilder {

    let separator = "|"
    var parameters = [String:[String]]()
    
    init() {
    
    }
    
    func addParameter(param: String, _ type: CategoryType) {

        if parameters[type.searchPattern] == nil {
            parameters[type.searchPattern] = [String]()
        }

        parameters[type.searchPattern]!.append(param)
    }
    
    func removeParameter(param: String, _ type: CategoryType) {
        if parameters[type.searchPattern] != nil {
            if let index = find(parameters[type.searchPattern]!, param) {
                parameters[type.searchPattern]!.removeAtIndex(index)
            }
        }
    }
    
    func getParamString(params: [AnyObject]) -> String {
        var paramString = ""
        for param in params {
            paramString += "\(param)\(separator)"
        }
        return paramString.rtrim(separator).gsub("\\/", "-")
    }
    
    func build() -> String {
        var query: String = ""
        for (type, params) in parameters {
            query += "\(type)="
            var paramString = getParamString(params)
            query += "\(paramString)&"
        }
        return query.rtrim("&")
    }
    
    func getParams(var _ paramsHash: [String:AnyObject] = [String:AnyObject]()) -> [String:String] {
        
        for (type, params) in parameters {
            paramsHash[type] = getParamString(params)
        }
        
        var finalHash = [String:String]()

        for (type, param) in paramsHash {
            finalHash[type] = "\(param)"
        }
        
        return finalHash
    }
    
}
