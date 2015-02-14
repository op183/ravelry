//
//  File.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

typealias OAuthResponseHandler = (NSData!, NSURLResponse!, NSError!) -> ()

protocol OAuthServiceDelegate {
    func accessTokenHasBeenFetched(accessToken: String, accessTokenSecret: String, username: String)
    func accessTokenHasExpired()
}

protocol OAuthServiceResultsDelegate {
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse)
}

class OAuthService: NSObject, NSURLConnectionDataDelegate {
    var delegate: OAuthServiceDelegate?
    var addParamsToAuthHeader = false
    
    let personalKey: String
    let consumerKey: String
    let consumerSecret: String

    var requestToken: String?
    var requestTokenSecret: String?
    let requestTokenCallback: String

    var accessToken: String?
    var accessTokenSecret: String?
    
    var username: String?
    
    let encoding: NSStringEncoding = NSUTF8StringEncoding
    
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

    init(consumerKey: String, consumerSecret: String, personalKey: String, requestTokenCallback: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.personalKey = personalKey
        self.requestTokenCallback = requestTokenCallback
    }

    func update(URLString: String, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(NSURL(string: URLString)!, params: params, method: "PUT", handler: handler)
    }

    func post(URLString: String, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(NSURL(string: URLString)!, params: params, method: "POST", handler: handler)
    }

    func post(URLString: String, handler: OAuthResponseHandler) {
        self.request(NSURL(string: URLString)!, params: [String:AnyObject](), method: "POST", handler: handler)
    }

    func post(URL: NSURL, handler: OAuthResponseHandler) {
        self.request(URL, params: [String:AnyObject](), method: "POST", handler: handler)
    }

    func get(URLString: String, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(NSURL(string: URLString)!, params: params, method: "GET", handler: handler)
    }


    func update(URL: NSURL, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(URL, params: params, method: "PUT", handler: handler)
    }

    func get(URL: NSURL, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(URL, params: params, method: "GET", handler: handler)
    }

    func post(URL: NSURL, params: [String:AnyObject], handler: OAuthResponseHandler) {
        self.request(URL, params: params, method: "POST", handler: handler)
    }

    
    func update(URL: NSURL, params: [String:AnyObject], delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: params, method: "PUT", delegate: delegate, action: action)
    }
    
    func get(URL: NSURL, params: [String:AnyObject], delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: params, method: "GET", delegate: delegate, action: action)
    }
    
    func post(URL: NSURL, params: [String:AnyObject], delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: params, method: "POST", delegate: delegate, action: action)
    }

    func destroy(URL: NSURL, params: [String:AnyObject], delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: params, method: "DELETE", delegate: delegate, action: action)
    }
    
    
    func post(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: [String:AnyObject](), method: "POST", delegate: delegate, action: action)
    }
    func get(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: [String:AnyObject](), method: "POST", delegate: delegate, action: action)
    }
    func update(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: [String:AnyObject](), method: "POST", delegate: delegate, action: action)
    }
    func destroy(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: ActionResponse = .Default) {
        self.request(URL, params: [String:AnyObject](), method: "POST", delegate: delegate, action: action)
    }
    
    func post(URL: NSURL, json: NSData, delegate: OAuthServiceResultsDelegate, action: ActionResponse) {
        self.request(URL, json: json, method: "POST", delegate: delegate, action: action)
    }

    func request(URL: NSURL, json: NSData, method: String, delegate: OAuthServiceResultsDelegate, action: ActionResponse) {
        
        var requestHeaders = getRequestHeaders()
        var signingKey = getSigningKey()
        
        sendRequest(URL,
            json: json,
            requestHeaders: &requestHeaders,
            signingKey: signingKey,
            method: method,
            completionHandler: getDefaultCompletionHandler(action, delegate: delegate)
        )

    }
    
    func request(URL: NSURL, params: [String:AnyObject], method: String, handler: OAuthResponseHandler, action: ActionResponse) {
        request(URL,
            params: params,
            method: method,
            handler: handler
        )
    }
    
    func request(URL: NSURL, params: [String:AnyObject], method: String, handler: OAuthResponseHandler) {

        var requestHeaders = getRequestHeaders()
        var signingKey = getSigningKey()

        sendRequest(
            URL,
            params: params,
            requestHeaders: &requestHeaders,
            signingKey: signingKey,
            method: method,
            completionHandler: handler
        )
    }
    
    func request(URL: NSURL, params: [String:AnyObject], method: String, delegate: OAuthServiceResultsDelegate, action: ActionResponse) {
        request(URL,
            params: params,
            method: method,
            handler: getDefaultCompletionHandler(action, delegate: delegate)
        )
    }
    
    func setAccessToken(accessToken: String, accessTokenSecret: String, username: String) {
        self.accessToken = accessToken
        self.username = username
        self.accessTokenSecret = accessTokenSecret
    }
    
    class func buildSignature(URL: NSURL, params: [String:AnyObject], signingKey: String, method: String) -> String? {
        var output = ""
        
        var keys = [String](params.keys)
        
        keys.sort({ return $0 < $1 })
        
        for key in keys {
            output += (key.percentEncode() + "=" + "\(params[key]!)".percentEncode() + "&")
        }
        
        output = output.rtrim("&").percentEncode()
        var absoluteURL = URL.absoluteString!.percentEncode()
        
        var signatureInput = "\(method)&\(absoluteURL)&\(output)"
        
        //println("Signature Input: \(signatureInput)")

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

            for var k = 18 - (remainder * 6); k >= 0; k -= 6 {
                var byte: Int = Int(binaryString & mask[k]!)
                var index: Int = byte >> k

                base64String.append(MIMEBase64Encoding[index])
            }
            
            
        }
        return base64String + padding
    }
    
    func getAccessToken(#token: String, verifier: String, username: String) {
        
        var requestHeaders: [String: AnyObject] = [
            "oauth_consumer_key": consumerKey,
            "oauth_nonce": generateNonce(),
            "oauth_timestamp": getTimestamp(),
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_token": self.requestToken!, //token,
            "oauth_verifier": verifier,
            "oauth_version": "1.0"
        ]
        
        var signingKey: String = "\(consumerSecret.percentEncode())&\(requestTokenSecret!.percentEncode())"
        
        sendRequest(accessTokenURL!,
            requestHeaders: &requestHeaders,
            signingKey: signingKey,
            method: "POST",
            completionHandler: { (data, response, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                var parts = [String:String]()
                let params = String(NSString(data: data!, encoding: self.encoding)!).split("&")
                
                for param in params {
                    let values = param.split("=")
                    let key: String = values[0]
                    let value: String = values[1]
                    parts[key] = value
                }
                
                self.accessToken = parts["oauth_token"]
                self.accessTokenSecret = parts["oauth_token_secret"]
                
                self.delegate!.accessTokenHasBeenFetched(
                    self.accessToken!,
                    accessTokenSecret: self.accessTokenSecret!,
                    username: username
                )
                
            }
        )
    }
    
    func getAccessToken(#URL: NSURL) {
        var matches = URL.absoluteString!.match(".*?\\?(.*)")
        var params = matches![0].split("&");
        var identifiers = [String:String]()
        
        for param in params {
            var parts = param.split("=")
            var key = parts[0]
            identifiers[key] = parts[1]
        }
        
        getAccessToken(
            token: identifiers["oauth_token"]!,
            verifier: identifiers["oauth_verifier"]!,
            username: identifiers["username"]!
        )
    }

    func getRequestToken() {
        var requestHeaders: [String: AnyObject] = [
            "oauth_callback": requestTokenCallback,
            "oauth_consumer_key": consumerKey,
            "oauth_nonce": generateNonce(),
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": getTimestamp(),
            "oauth_version": "1.0"
        ]

        var signingKey: String = consumerSecret.percentEncode() + "&"

        sendRequest(requestTokenURL!,
            requestHeaders: &requestHeaders,
            signingKey: signingKey,
            method: "POST",
            completionHandler: { (data, response, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                //println("error: \(error)")
                
                var parts = [String:String]()
                
                let params = String(NSString(data: data!, encoding: self.encoding)!)
                let parseParams = params.split("&")
                
                for param in parseParams {
                    let values = param.split("=")
                    
                    let key: String = values[0]
                    let value: String = values[1]
                    parts[key] = value
                }
                
                self.requestToken = parts["oauth_token"]
                self.requestTokenSecret = parts["oauth_token_secret"]
                var request = NSURL(string: "\(self.authorizeURL!.absoluteString!)?oauth_token=\(self.requestToken!)")
                UIApplication.sharedApplication().openURL(request!)
            }
        )
    }
 
    func getTimestamp() -> String {
        return String(Int64(NSDate().timeIntervalSince1970))
    }
    
    func sendRequest(var URL: NSURL, params: [String: AnyObject], inout requestHeaders: [String: AnyObject], signingKey: String, method: String, completionHandler: OAuthResponseHandler) {
    
        var newParams = [String:AnyObject]()
        
        for (key, param) in params {
            if let pstring = param as? String {
                if pstring != "" {
                    newParams[key] = pstring
                }
            } else {
                newParams[key] = param
            }
        }
        
        var oAuthHeaders = newParams + requestHeaders

        requestHeaders["oauth_signature"] = OAuthService.buildSignature(
            URL,
            params: oAuthHeaders,
            signingKey: signingKey,
            method: method
        )!
        
        var request: NSMutableURLRequest?
        
        switch method {
            case "POST", "DELETE", "PUT":
                request = getRequest(URL, method: method)
                request!.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                var bodyString = OAuthService.buildBodyString(newParams)
                request!.HTTPBody = bodyString
            default:
                request = getRequest(NSURL(string: OAuthService.getAbsoluteURL(URL, params))!, method: method)
        }
        
        var header = ""
        if addParamsToAuthHeader {
            header = buildAuthorizationHeader(oAuthHeaders)
            addParamsToAuthHeader = false
        } else {
            header = buildAuthorizationHeader(requestHeaders)
        }

        request!.setValue(header, forHTTPHeaderField: "Authorization")
    
        self.getSession().dataTaskWithRequest(request!,
            completionHandler: completionHandler
        ).resume()
    }
    
    func sendRequest(URL: NSURL, inout requestHeaders: [String: AnyObject], signingKey: String, method: String, completionHandler: OAuthResponseHandler) {
        
        self.sendRequest(
            URL,
            params: [String: AnyObject](),
            requestHeaders: &requestHeaders,
            signingKey: signingKey,
            method: method,
            completionHandler: completionHandler
        )
    }
    
    func sendRequest(URL: NSURL, json: NSData, inout requestHeaders: [String: AnyObject], signingKey: String, method: String, completionHandler: OAuthResponseHandler) {
        
        var request = getRequest(URL, method: method)

        requestHeaders["oauth_signature"] = OAuthService.buildSignature(
            URL,
            params: requestHeaders,
            signingKey: signingKey,
            method: method
        )!
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.HTTPBody = json
        
        var header = buildAuthorizationHeader(requestHeaders)
        
        request.setValue(header, forHTTPHeaderField: "Authorization")
        
        self.getSession().dataTaskWithRequest(request,
            completionHandler: completionHandler
        ).resume()
    }
    
    func getRequestHeaders() -> [String: AnyObject] {
        return [
            "oauth_consumer_key": consumerKey,
            "oauth_token": accessToken!,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": getTimestamp(),
            "oauth_nonce": generateNonce(),
            "oauth_version": "1.0"
        ]
    }

    func getSigningKey() -> String {
        return "\(consumerSecret.percentEncode())&\(accessTokenSecret!.percentEncode())"
    }
    
    func getRequest(URL: NSURL, method: String) -> NSMutableURLRequest {
        
        var request = NSMutableURLRequest(
            URL: URL,
            cachePolicy: .ReturnCacheDataElseLoad,
            timeoutInterval: 120
        )
        
        request.HTTPMethod = method
        request.HTTPShouldHandleCookies = false
        return request
    }
    
    func getSession() -> NSURLSession {
        var sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        var session = NSURLSession(configuration: sessionConfig)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return session
    }
    
    func sortParamaters(params: [String: AnyObject]) -> [String: AnyObject] {
        var parameters = [String: AnyObject]()
        var keys = [String](params.keys)
        keys.sort({ return $0 < $1 })
        
        for key in keys {
            parameters[key] = params[key]!
        }

        return parameters
    }
    
    class func getAbsoluteURL(URL: NSURL, _ params: [String: AnyObject]) -> String {
        var urlString = URL.absoluteString!
        var paramString = buildParamString(params)
        return "\(urlString)\(paramString)"
    }
    
    class func buildBodyString(bodyElements: [String:AnyObject]) -> NSData? {
        
        var bodyString = ""
        
        for (k, v) in bodyElements {
            var key = k.percentEncode()
            var value = "\(v)".gsub(" ", "+").percentEncode(ignore: ["+"])
            bodyString += "\(key)=\(value)&"
        }
        bodyString = bodyString.rtrim("& ")
        
        println(bodyString)
        return bodyString.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    class func buildParamString(params: [String: AnyObject]) -> String {
        if countElements(params) > 0 {
            var paramString = "?"
            
            var keys = [String](params.keys)
            keys.sort({ return $0 < $1 })

            for key in keys {
                var value = "\(params[key]!)"
                paramString += key.percentEncode()  + "=" + value.percentEncode(ignore: ["+", "-"])  + "&"
            }
            
            return paramString.rtrim("&")
        } else {
            return ""
        }
    }
    
    class func buildURL(URLString: String, params: [String: AnyObject]) -> NSURL? {
        var paramString = self.buildParamString(params)
        return NSURL(string: "\(URLString)\(paramString)")
    }

    
    func buildAuthorizationHeader(params: [String: AnyObject], URL: NSURL? = nil) -> String {
        var header: String = "OAuth "
        
        if URL != nil {
            header += "realm=\"\(URL!.absoluteString!)\", "
        }
        
        var keys = [String](params.keys)
        keys.sort({ return $0 < $1 })
        
        for key in keys {
            var akey = key.percentEncode()
            var aval = "\(params[key]!)".percentEncode()
            header += "\(akey)=\"\(aval)\", "
        }

        return header.rtrim(", ")
    }
    
    class func jsonStringify(data: AnyObject) -> NSData? {
        var error: NSError?
        
        if let json = NSJSONSerialization.dataWithJSONObject(
            data,
            options: NSJSONWritingOptions(0),
            error: &error
            ) {
                return json
        } else {
            println("There was an issue converting your object to json")
            return nil
        }
    }
    
    let nonceTable: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    
    func generateBoundaryString() -> String {
        return String(format:"---------------------------%@", generateNonce(digits: 12))
    }
    
    func generateNonce(digits: Int = 7) -> String {
        var nonce: String = ""
        
        for i in 0...digits {
            var index = Int((arc4random() % 62))
            nonce += String([nonceTable[index]])
        }

        return nonce
    }
        
    func getDefaultCompletionHandler(action: ActionResponse, delegate: OAuthServiceResultsDelegate) -> OAuthResponseHandler {
        
        return getDefaultCompletionHandler { (data: NSData!) in
            println("Action Completed: \(action.rawValue)")
            delegate.resultsHaveBeenFetched(data, action: action)
        }
        
    }
    
    func getDefaultCompletionHandler(handler: (NSData!) -> ()) -> OAuthResponseHandler {
        return { (data, response, error) in
            
            if let r = response as? NSHTTPURLResponse  {
                var statusCode = r.statusCode
                switch statusCode {
                case 200:
                    println("Success: 200")
                    //println(data.toString())
                    handler(data)
                case 408:
                    println("408: Network Timeout")
                case 415:
                    println("415: Unsupported Media Type")
                default:
                    println("Status: \(statusCode)")
                }
            } else {
                println(error)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        }
    
    }
    
    func doAsyncRequest(request: NSMutableURLRequest, handler: (NSData!) -> ()) {
        
        getSession()
            .dataTaskWithRequest(request, completionHandler: getDefaultCompletionHandler(handler))
            .resume()
        
    }
    
    func doAsyncRequest(request: NSMutableURLRequest, delegate: OAuthServiceResultsDelegate, action: ActionResponse) {
        doAsyncRequest(request) { data in
            delegate.resultsHaveBeenFetched(data, action: action)
        }
    }
    
    func postUnauthorizedRequest(URL: NSURL, params: [String:AnyObject], headers: [String:String], handler: (NSData!) -> ()) {
        let request = getRequest(URL, method: "POST")
        
        for (header, value) in headers {
            request.setValue(header, forHTTPHeaderField: value)
        }
        
        request.HTTPBody = OAuthService.buildBodyString(params)
        doAsyncRequest(request, handler: handler)
    }
    
    func sendBasicRequest(URL: NSURL, delegate: OAuthServiceResultsDelegate, action: ActionResponse) {
        var request = getBasicAuthorizationRequest(URL)
        doAsyncRequest(request, delegate: delegate, action: action)
    }
    
    func getBasicAuthorizationRequest(URL: NSURL, method: String = "GET") -> NSMutableURLRequest {
        let request = getRequest(URL, method: method)
        let encodedAuth = "Basic " + "\(consumerKey):\(personalKey)".base64;
        request.addValue(encodedAuth, forHTTPHeaderField: "Authorization")
        return request
    }
    
    var response: NSURLResponse?
    var data: NSData?

}
