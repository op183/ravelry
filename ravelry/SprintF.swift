//
//  SprintF.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/1/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import Foundation

typealias LazyVarArgClosure = @autoclosure() -> CVarArgType

func sprintf(format: @autoclosure() -> String, vargs: LazyVarArgClosure...) -> String {
    var formattedString = format().gsub("/%s/", "/%@s/")
    
    let realArgs:[CVarArgType] = vargs.map { (lazyArg: LazyVarArgClosure) in
        println(lazyArg())
        return lazyArg()
    }
    
    func curriedStringWithFormat(valist: CVaListPointer) -> String {
        return NSString(format: formattedString, arguments: valist)
    }
    
    return withVaList(realArgs, curriedStringWithFormat)
}