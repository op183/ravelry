//
//  File.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class OAuthService: NSObject, UIApplicationDelegate {
    var client: String?
    var resourceServer: String?
    var resourceOwner: String?

    let consumerKey: String
    let consumerSecret: String

    
    var requestTokenURL: NSURL? {
        get {
            return nil
        }
    }
    
    var accessTokenURL: NSURL? {
        get {
            return nil
        }
    }
    
    var authorizeURL: NSURL? {
        get {
            return nil
        }
    }
    
    var requestTokenCallback: String {
        get {
            return ""
        }
    }

    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    
    func authenticate() {
        obtainRequestToken()
    }
    
    func application(application: UIApplication, openURL: NSURL, sourceApplication: String?, annotation: AnyObject?) {
        var requestToken = ""
        println("Response \(openURL)")
        redirectToUserLogin()
        var accessToken = exchangeRequestTokenForAccessToken(requestToken)
        
    }
    
    class func buildSignature(headers: [String: String], method: String, url: String, signingKey: String) -> String? {
        var output = ""
        
        var keys = [String](headers.keys)
        
        keys.sort({ return $0 < $1 })
        
        for key in keys {
            var value = headers[key]!
            output += (key.percentEncode() + "=" + value.percentEncode() + "&")
        }
        
        output = output.rtrim("&").percentEncode()
        
        var signatureInput = method + "&" + url.percentEncode() + "&" + output
        
        var signatureOutput = OAuthService.applyHashingAlgorithm(
            signatureInput,
            algorithm: HMACAlgorithm.SHA1,
            key: signingKey
        )

        return signatureOutput
    }

    class func applyHashingAlgorithm(string: String, algorithm: HMACAlgorithm, key: String) -> String {
        var data = string.dataUsingEncoding(NSUTF8StringEncoding)
        
        let string = UnsafePointer<UInt8>(data!.bytes)
        let stringLength = UInt(data!.length)
        let digestLength = algorithm.digestLength()
        
        let keyString = key.cStringUsingEncoding(NSUTF8StringEncoding)!
        let keyLength = UInt(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        var result = [UInt8](count: digestLength, repeatedValue: 0)
        
        CCHmac(algorithm.toCCEnum(), keyString, keyLength, string, stringLength, &result)
        
        var hash: String = ""
        var base64String: String = ""
        var binaryString: UInt32 = 0
        
        var mask: [Int: UInt32] = [
            0: 0b111111,
            6: 0b111111 << 6,
            12: 0b111111 << 12,
            18: 0b111111 << 18,
        ]

        var iteration = 0;
        
        for i in 0..<digestLength {
            
            binaryString <<= 8
            binaryString |= UInt32(result[i])
            
            //println(String(UInt32(result[i]), radix: 2) + ": " + String(format: "%02X", result[i]))
            //println(String(binaryString, radix: 2))
            
            //println(i % 3)
            //println(String(binaryString, radix: 2))
            iteration = i % 3
            
            if i % 3 == 2 {
                var b1: Int = Int(binaryString & mask[18]!)
                var b2: Int = Int(binaryString & mask[12]!)
                var b3: Int = Int(binaryString & mask[6]!)
                var b4: Int = Int(binaryString & mask[0]!)
                
                var ix1: Int = b1 >> 18
                var ix2: Int = b2 >> 12
                var ix3: Int = b3 >> 6
                var ix4: Int = b4
                
                base64String.append(MIMEBase64Encoding[ix1])
                base64String.append(MIMEBase64Encoding[ix2])
                base64String.append(MIMEBase64Encoding[ix3])
                base64String.append(MIMEBase64Encoding[ix4])
                /*
                println("Base 18")
                println(String(binaryString, radix: 2))
                println(String(mask[18]!, radix: 2))
                println(String(b1, radix: 2))

                println("Base 12")
                println(String(binaryString, radix: 2))
                println(String(mask[12]!, radix: 2))
                println(String(b2, radix: 2))
 
                println("Base 6")
                println(String(binaryString, radix: 2))
                println(String(mask[6]!, radix: 2))
                println(String(b3, radix: 2))
                
                println("Base 0")
                println(String(binaryString, radix: 2))
                println(String(mask[0]!, radix: 2))
                println(String(b4, radix: 2))
                
                
                println("\(ix1) \(ix2) \(ix3) \(ix4)")
                println("\(MIMEBase64Encoding[ix1])\(MIMEBase64Encoding[ix2])\(MIMEBase64Encoding[ix3])\(MIMEBase64Encoding[ix4])")
                */
                binaryString = 0

            }
        }
        var padding = ""
        if binaryString > 0 {
            let remainder = Int(2 - iteration)

            for var j = 0; j < remainder; ++j {
                padding += "="
                binaryString <<= 2
            }

            var b1: Int = Int(binaryString & mask[18]!)
            var b2: Int = Int(binaryString & mask[12]!)
            var b3: Int = Int(binaryString & mask[6]!)
            var b4: Int = Int(binaryString & mask[0]!)
            
            var ix1: Int = b1 >> 18
            var ix2: Int = b2 >> 12
            var ix3: Int = b3 >> 6
            var ix4: Int = b4
            
            base64String.append(MIMEBase64Encoding[ix1])
            base64String.append(MIMEBase64Encoding[ix2])
            base64String.append(MIMEBase64Encoding[ix3])
            base64String.append(MIMEBase64Encoding[ix4])
        }


        println(base64String + padding)
        return base64String + padding
    }
    
    
    private
    func obtainRequestToken() {

        var currentDate = NSDate()
        var timestamp =  NSString(format: "%d", Int(currentDate.timeIntervalSince1970))
        
        println("Date \(currentDate), Timestamp \(timestamp)")

        var requestHeaders = [
            "oauth_callback": "oob",//requestTokenCallback,
            "oauth_consumer_key": consumerKey,
            "oauth_nonce": generateNonce(),
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": timestamp,
            "oauth_version": "1.0",
        ]

        var signingKey: String = consumerSecret.percentEncode() + "&"
        
        println("Signing Key \(signingKey)")
        
        requestHeaders["oauth_signature"] = OAuthService.buildSignature(requestHeaders,
            method: "POST",
            url: NSString(format: "%@s", requestTokenURL!),
            signingKey: signingKey
        )
        
        var authHeader = buildAuthorizationHeader(requestHeaders)
        
        println(authHeader)

        var mutableRequest = NSMutableURLRequest(URL: requestTokenURL!)
        mutableRequest.addValue(authHeader, forHTTPHeaderField: "Authorization")
        mutableRequest.HTTPMethod = "POST"

        var request = mutableRequest as NSURLRequest
        
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var parsedData = NSString(data: data, encoding: 8)
                println("Connection Complete \(response)")
                println("Connection Data \(parsedData)")
            }
        )
        
    
    }
    
    func buildAuthorizationHeader(params: [String: String]) -> String {
        var header: String = "OAuth "
        
        var keys = [String](params.keys)
        keys.sort({ return $0 < $1 })
        
        for key in keys {
            header += key.percentEncode() + "=\"" + params[key]!.percentEncode() + "\", "
        }

        return header.rtrim(", ")
    }
    
    func redirectToUserLogin() {
        
    }

    func exchangeRequestTokenForAccessToken(requestToken: String) -> String {
        return ""
    }

    
    let nonceTable: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    
    func generateNonce() -> String {
        var nonce: String = ""
        
        for i in 0...5 {
            var index = Int((arc4random() % 62))
            nonce += String([nonceTable[index]])
        }

        return nonce
    }

}

class RavelryOAuthService: OAuthService {
    override var requestTokenURL: NSURL? {
        get {
            return NSURL(
                scheme: "https",
                host: "www.ravelry.com",
                path: "/oauth/request_token"
            )
        }
    }

    override var accessTokenURL: NSURL? {
        get {
            return NSURL(
                scheme: "https",
                host: "www.ravelry.com",
                path: "/oauth/access_token"
            )
        }
    }

    override var authorizeURL: NSURL? {
        get {
            return NSURL(
                scheme: "https",
                host: "www.ravelry.com",
                path: "/oauth/authorize"
            )
        }
    }
    
    override var requestTokenCallback: String {
        get {
            return "ravelry://requesttoken".urlencode()
        }
    }
}
