//
//  NSData.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/5/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

extension NSData {

    func toJSON(options: NSJSONReadingOptions? = nil) -> NSDictionary? {
        
        var parseError: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(
            self,
            options: (options != nil) ? options! : nil,
            error: &parseError
            ) as? NSDictionary {
            return json
        }
        
        return nil
    }
    
    func toString(encoding: UInt = NSUTF8StringEncoding) -> String? {
        if let s = NSString(data: self, encoding: encoding) as? String {
            println("Connection Received Data \(s)")
            return s
        } else {
            return nil
        }
    }
    
    var mimeType: String? {
        var byteString: UInt8 = UInt8.allZeros
        self.getBytes(&byteString, length: 1)
        switch byteString {
            case 0xFF:
                return "image/jpeg"
            case 0x89:
                return "image/png"
            case 0x47:
                return "image/gif"
            case 0x49, 0x4D:
                return "image/tiff"
            default:
                return nil
        }
    }
}

extension NSMutableData {
    func appendString(string: String, encoding: UInt = NSUTF8StringEncoding, allowLossyConversion: Bool = true) {
        let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion)
        appendData(data!)
    }
}