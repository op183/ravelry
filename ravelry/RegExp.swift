//
//  regex.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/14/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class RegExp {
    
    var pattern: String = ""
    var replacement: String = ""
    var options: NSRegularExpressionOptions = NSRegularExpressionOptions.allZeros
    var mOptions: NSMatchingOptions = NSMatchingOptions.allZeros
    
    init(_ pattern: String, _ options: String = "") {
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
    
    func match(input: String) -> [String]? {
        var capacity = countElements(input)
        var mutable = NSMutableString(capacity: capacity)
        var matches = [String]()
        
        mutable.appendString(input)
        
        var results = doRegExp()!
            .matchesInString(
                mutable,
                options: mOptions,
                range: NSMakeRange(
                    0,
                    capacity
                )
            ) as [NSTextCheckingResult]
        var numRanges: Int
        var range: NSRange
        
        for result in results {
            numRanges = result.numberOfRanges - 1
            if numRanges >= 1 {
                for i in 1...numRanges {
                    range = result.rangeAtIndex(i)
                    
                    matches.insert(input.substringWithRange(
                        Range(
                            start: advance(input.startIndex, range.location),
                            end: advance(input.startIndex, range.location + range.length)
                        )
                    ), atIndex: i - 1)
                }
            }
        }
        
        if matches.count > 0 {
            return matches
        } else {
            return nil
        }
        
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

let MIMEBase64Encoding: [Character] = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "+", "/"
]

let RestrictedRegexCharacters: [Character] = [
    "[", ".", "+", "*", "/", "{", "\\", "(", ")", "|", "$", "^"
]

let WhitelistedPercentEncodingCharacters: [UnicodeScalar] = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    ".", "-", "_", "~"
]


extension String {
    
    var base64: String {
        
        var encoded: String = ""
        var base: UInt64 = 0
        var i: UInt64 = 0
        var padding: String = ""
        
        for character in self.unicodeScalars {
            
            if i < 3 {
                base = base << 8 | UInt64(character)
                ++i
            } else {
                for i = 3; i > 0; --i {
                    let bitmask: UInt64 = 0b111111 << (i * 6)
                    encoded.append(
                        MIMEBase64Encoding[Int((bitmask & base) >> (i * 6))]
                    )
                }
                encoded.append(
                    MIMEBase64Encoding[Int(0b111111 & base)]
                )
                base = UInt64(character)
                i = 1
            }
        }
        
        let remainder = Int(3 - i)
        for var j = 0; j < remainder; ++j {
            padding += "="
            base <<= 2
        }
        
        let iterations: UInt64 = (remainder == 2) ? 1 : 2
        
        for var k: UInt64 = iterations ; k > 0; --k {
            let bitmask: UInt64 = 0b111111 << (k * 6)
            
            encoded.append(
                MIMEBase64Encoding[Int((bitmask & base) >> (k * 6))]
            )
        }
        
        encoded.append(
            MIMEBase64Encoding[Int(0b111111 & base)]
        )
        
        return encoded + padding
    }
    
    func split(delimiter: String) -> [String] {
        var parsedDelimiter: String = ""
        
        for d in delimiter.unicodeScalars {
            if contains(RestrictedRegexCharacters, Character(delimiter)) {
                parsedDelimiter += "\\\\\(d)"
            } else {
                parsedDelimiter.append(d)
            }
        }
        
        if let matches = self.match("(.+?)(?:\(parsedDelimiter)|$)") {
            return matches.reverse()
        } else {
            return [self]
        }
    }
    
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
        return regex.match(self)
    }

    func match(pattern: String, _ options: String) -> [String]? {
        var regex = RegExp(pattern, options)
        return regex.match(self)
    }

    func trim(_ characters: String = "") -> String {
        return self.gsub("^[\\s\(characters)]+|[\\s\(characters)]+$", "$1")
    }
    
    func rtrim(_ characters: String = "") -> String {
        return self.gsub("[\\s\(characters)]+$", "$1")
    }
    
    func ltrim(_ characters: String = "") -> String {
        return self.gsub("^[\\s\(characters)]+", "$1")
    }
    
    func test(pattern: String) -> Bool {
        var regex = RegExp(pattern)
        return (regex.numMatches(self)! > 0) ? true : false;
    }
    
    func urlencode() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    func percentEncode() -> String {
        var output = ""
        
        for char in self.unicodeScalars {
            if contains(WhitelistedPercentEncodingCharacters, char) {
                output.append(char)
            } else {
                output += NSString(format: "%%%02X", UInt8(char))
            }
        }
        
        return output
    }
    
    func toURL() -> NSURL? {
        var matches: [String]? = self.match("(http|https):\\/\\/(.*?)(\\/.*)");
        
        if matches != nil && matches!.count == 3 {
            var url = NSURL(
                scheme: matches![0],
                host: matches![1],
                path: matches![2]
            )
            
            if url != nil {
                return url
            }
        }
        
        return nil
    }
    
    subscript(pattern: String, replacement: String) -> String {
        get {
            return gsub(pattern, replacement)
        }
    }
}
