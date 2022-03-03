//
//  QiNiuTools.swift
//  ShakeImage
//
//  Created by MacMini on 2022/3/3.
//

import Foundation

class QiNiuTools {
    let deadline = String(Date().timeIntervalSince1970 + 365 * 24 * 60 * 60)
    let bucket = "kokofiles"
    let accessKey = "MR8RPHriYToU4xtQUo-DkQft5yCXJMTjU7hr3OeV"
    let secretKey = "X4IlA-y3kkIrqsOePr4M9ilhcO5Au9TTBDLAAeEC"
    
    static var filePath = String()
    static var sharedInstance = QiNiuTools()
        
    init() {
        
    }
    /*
    func createToken() {
        var jsonDict: [String: Any] = [:]
        jsonDict["scope"] = bucket
        jsonDict["deadline"] = deadline
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let encoded = self.urlSafeBase64Encode(text: jsonData!)
        let encoded_signed =
    }
    
    func urlSafeBase64Encode(text: Data) -> String {
        var base64 = String(data: QN_GTM_Base64.encode(text), encoding: String.Encoding.utf8)
        base64 = base64?.replacingOccurrences(of: "+", with: "-")
        base64 = base64?.replacingOccurrences(of: "/", with: "_")
        return base64 ?? ""
    }
    
    func hmacsha1(_ key: String, text: String) -> String? {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = text.cString(using: String.Encoding.utf8)
        let cHMAC = [Int8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC)
        let HMAC = Data(bytes: &cHMAC, length: CC_SHA1_DIGEST_LENGTH)
        let hash = urlSafeBase64Encode(HMAC)
        
        return hash
    }
    */
    
    func token() -> String {
        return self.createQiniuToken()
    }
    
    func createQiniuToken() -> String {
        let secretKeyStr = secretKey.utf8CString
        let policy = self.marshal()
        let policyData = policy.data(using: String.Encoding.utf8)
        let encodedPolicy = QN_GTM_Base64.string(byWebSafeEncoding: policyData, padded: true)
        let encodedPolicyStr = encodedPolicy?.cString(using: String.Encoding.utf8)
        
        let digestStr = [Int8](repeating: 0, count: 20)
        // bzero(digestStr, 0)
        return ""
    }
    
    func marshal() -> String {
        var jsonDict: [String: Any] = [:]
        jsonDict["scope"] = bucket
        jsonDict["deadline"] = deadline
        let json = self.jsonStringWithPrettyPrint(prettyPrint: true, dict: jsonDict)
        return json
    }
    
    func jsonStringWithPrettyPrint(prettyPrint: Bool, dict: [String: Any]) -> String {
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(
                withJSONObject: dict,
                options: JSONSerialization.WritingOptions(rawValue: (prettyPrint ? JSONSerialization.WritingOptions.prettyPrinted.rawValue : 0)))
            return String(data: jsonData!, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    func jsonDictionaryToString(dictionary: [String: Any]) -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonStr = String(data: jsonData!, encoding: .utf8)
        return jsonStr
    }

    func jsonStringToDictionary(string: String) -> [String: Any]? {
        let jsonData = string.data(using: .utf8)
        let jsonDic = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
        return jsonDic
    }
}
