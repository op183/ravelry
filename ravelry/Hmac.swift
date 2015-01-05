import Foundation

public enum HMACAlgorithm: Printable {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    public var description: String {
        get {
            switch self {
            case .MD5:
                return "HMAC.MD5"
            case .SHA1:
                return "HMAC.SHA1"
            case .SHA224:
                return "HMAC.SHA224"
            case .SHA256:
                return "HMAC.SHA256"
            case .SHA384:
                return "HMAC.SHA384"
            case .SHA512:
                return "HMAC.SHA512"
            }
        }
    }
}

extension String {
    public func sign(algorithm: HMACAlgorithm, key: String) -> String {
        var data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.sign(algorithm, key: key)
    }
}

extension NSData {
    public func sign(algorithm: HMACAlgorithm, key: String) -> String {
        let string = UnsafePointer<UInt8>(self.bytes)
        let stringLength = UInt(self.length)
        let digestLength = algorithm.digestLength()

        let keyString = key.cStringUsingEncoding(NSUTF8StringEncoding)!
        let keyLength = UInt(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        var result = [UInt8](count: digestLength, repeatedValue: 0)
        
        CCHmac(algorithm.toCCEnum(), keyString, keyLength, string, stringLength, &result)
        
        var hash: String = ""
        for i in 0..<digestLength {
            hash += String(format: "%02x", result[i])
        }
        
        return hash
    }
}