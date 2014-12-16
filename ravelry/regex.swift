//
//  regex.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/14/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

infix operator =~ {}

func =~ (input: String, pattern: String) -> Bool {
    return input.test(pattern)
}

//infix operator % {}

/*
func % (input: String, format: CVarArgType...) -> String {
return sprintf(input, format)
}

func sprintf(format: String, args: [CVarArgType]) -> String {
var args2 = getVaList(args)
return NSString(format: format, arguments: args2)
}
*/

class RegExp {
    
    var pattern: String = ""
    var replacement: String = ""
    var options: NSRegularExpressionOptions = NSRegularExpressionOptions.allZeros
    var mOptions: NSMatchingOptions = NSMatchingOptions.allZeros
    
    init(_ pattern: String, options: String = "") {
        setOptions(options)
        self.pattern = pattern; //formatPattern(pattern)
    }
    
    func numMatches(input: String) -> Int? {
        var capacity = countElements(input)
        var mutable = NSMutableString(capacity: capacity)
        mutable.appendString(input)
        
        return doRegExp()!
            .numberOfMatchesInString(
                mutable,
                options: mOptions,
                range: NSMakeRange(
                    0,
                    capacity
                )
        )
        
    }
    
    func match(input: String) -> [AnyObject]? {
        var capacity = countElements(input)
        var mutable = NSMutableString(capacity: capacity)
        
        mutable.appendString(input)
        
        return doRegExp()!
            .matchesInString(
                mutable,
                options: mOptions,
                range: NSMakeRange(
                    0,
                    capacity
                )
        )
    }
    
    
    func gsubi(string: String, _ replacement: String) -> String {
        setOptions("i");
        return replace(string, replacement)
    }
    
    func gsub(string: String, _ replacement: String) -> String {
        mOptions = NSMatchingOptions.allZeros;
        return replace(string, replacement)
    }
    
    private
    
    func replace(string: String, _ replacement: String) -> String {
        self.replacement = replacement
        
        var capacity = countElements(string)
        var mutable = NSMutableString(
            capacity: capacity
        )
        
        mutable.appendString(string)
        println(replacement)
        
        doRegExp()!.replaceMatchesInString(
            mutable,
            options: mOptions,
            range: NSMakeRange(
                0,
                capacity
            ),
            withTemplate: self.replacement
        )
        
        
        return mutable as String
    }
    
    func setMatchingOptions(flags: String) ->NSMatchingOptions {
        var options = NSMatchingOptions.allZeros
        
        NSMatchingOptions.ReportProgress
        NSMatchingOptions.ReportCompletion
        NSMatchingOptions.Anchored
        NSMatchingOptions.WithTransparentBounds
        NSMatchingOptions.WithoutAnchoringBounds
        
        self.mOptions = options
        
        return options;
        
    }
    
    func setOptions(flags: String) -> NSRegularExpressionOptions {
        
        var options: NSRegularExpressionOptions = NSRegularExpressionOptions.allZeros
        
        for character in flags as String {
            switch(character) {
            case("i"):
                options |= NSRegularExpressionOptions.CaseInsensitive
            case("x"):
                options |= NSRegularExpressionOptions.AllowCommentsAndWhitespace
            case("s"):
                options |= NSRegularExpressionOptions.DotMatchesLineSeparators
            case("m"):
                options |= NSRegularExpressionOptions.AnchorsMatchLines
            case("w"):
                options |= NSRegularExpressionOptions.UseUnicodeWordBoundaries
                
                //last two are subject to change
            case("c"):
                options |= NSRegularExpressionOptions.IgnoreMetacharacters
            case("l"):
                options |= NSRegularExpressionOptions.UseUnixLineSeparators
            default:
                options |= NSRegularExpressionOptions.allZeros
            }
        }
        
        self.options = options
        
        return options;
    }
    
    func doRegExp() -> NSRegularExpression? {
        
        var error: NSError?
        
        var regex = NSRegularExpression(
            pattern: pattern,
            options: options,
            error: &error
        )
        
        return regex
    }
    
}

extension String {
    
    func gsub(pattern: String, _ replacement: String) -> String {
        var regex = RegExp(pattern)
        return regex.gsub(self, replacement)
    }
    
    func gsubi(pattern: String, _ replacement: String) -> String {
        var regex = RegExp(pattern)
        return regex.gsubi(self, replacement)
    }
    
    func match(pattern: String) -> [String]? {
        var regex = RegExp(pattern)
        var matches: [String] = regex.match(self) as [String]
        return matches
    }
    
    func trim(_ characters: String = "") -> String {
        return self.gsub("^[\\s\(characters)]+|[\\s\(characters)]+$", "")
    }
    
    func rtrim(_ characters: String = "") -> String {
        return self.gsub("[\\s\(characters)]+$", "")
    }
    
    func ltrim(_ characters: String = "") -> String {
        return self.gsub("^[\\s\(characters)]+", "")
    }
    
    func test(pattern: String) -> Bool {
        var regex = RegExp(pattern)
        return (regex.numMatches(self)! > 0) ? true : false;
    }
    
    subscript(pattern: String, replacement: String) -> String {
        get {
            return gsub(pattern, replacement)
        }
    }
}