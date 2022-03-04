//
//  QiNiuTools.swift
//  ShakeImage
//
//  Created by MacMini on 2022/3/3.
//

import Foundation

class QiNiuTools {
    let bucket = "kokofiles"
    let accessKey = "MR8RPHriYToU4xtQUo-DkQft5yCXJMTjU7hr3OeV"
    let secretKey = "X4IlA-y3kkIrqsOePr4M9ilhcO5Au9TTBDLAAeEC"
        
    static let shared = QiNiuTools()
    private init() {}
    
    func jsonStringWithPrettyPrint(prettyPrint: Bool, dict: Dictionary<String, String>) -> String {
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(
                withJSONObject: dict,
                options: JSONSerialization.WritingOptions(rawValue: (prettyPrint ? JSONSerialization.WritingOptions.prettyPrinted.rawValue : 0)))
            if jsonData != nil {
                return String(data: jsonData!, encoding: .utf8) ?? ""
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
    func makeShal() -> String {
        let deadline = Date().timeIntervalSince1970 + 3600
        let dict = [
            "scope": bucket,
            "deadline": String(deadline)
        ]
        let json = self.jsonStringWithPrettyPrint(prettyPrint: true, dict: dict)
        return json
    }
    
    func createQiNiuToken() -> String {
        let secretKeyStr = secretKey.utf8CString as? UnsafePointer<CChar>
        let policy = self.makeShal()
        let policyData = policy.data(using: .utf8)
        let encodedPolicy = QN_GTM_Base64.string(byWebSafeEncoding: policyData, padded: true)
        let encodedPolicyStr = encodedPolicy?.cString(using: .utf8)
        
        var digestStr = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretKeyStr, Int(strlen(secretKeyStr!)), encodedPolicyStr, Int(strlen(encodedPolicyStr!)), &digestStr)
        let encodedDigest = QN_GTM_Base64.string(byWebSafeEncodingBytes: digestStr, length: UInt(CC_SHA1_DIGEST_LENGTH), padded: true)!
        let token = accessKey + ":" + encodedDigest + ":" + encodedPolicy!
        print("QiNiuToken=\(token)")
        return token
    }
    /*
    func hmacsha1WithString(str: String) -> NSData {
        let cKey  = secretKey.cString(using: String.Encoding.ascii)
        let cData = str.cString(using: String.Encoding.ascii)
        
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData: NSData = NSData(bytes: result, length: (Int(CC_SHA1_DIGEST_LENGTH)))
        return hmacData
    }
    
    func createToken(fileName: String) -> String {
        let oneHourLater = NSDate().timeIntervalSince1970 + 3600
        let putPolicy: NSDictionary = ["scope": bucket, "deadline": NSNumber(value: UInt64(oneHourLater))]
        let encodedPutPolicy = QNUrlSafeBase64.encode(putPolicy.dataUsingEncoding(String.Encoding.utf8))
        let sign = self.hmacsha1WithString(str: encodedPutPolicy!, secretKey: secretKey)
        let encodedSign = QNUrlSafeBase64.encode(sign as! Data)
                
        return accessKey + ":" + encodedSign! + ":" + encodedPutPolicy!
    }
    */
}
