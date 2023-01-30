//
//  AesTool.swift
//  ShakeImage
//
//  Created by MacMini on 1/18/23.
//

import Foundation
import CryptoSwift

class AesTool {
    public static func encryptAes(jsonDict: [String: Any], aesKey: String) -> String {
        // 从字典转成data
        let data = try? JSONSerialization.data(withJSONObject: jsonDict)
        // byte数组
        var encrypted: [UInt8] = []
        do {
            let privateKeyArr: [UInt8] = Array(aesKey.utf8)
            let aesIVArr: [UInt8] = Array(aesIV.utf8)
            encrypted = try AES(key: privateKeyArr, blockMode: CBC(iv: aesIVArr), padding: .pkcs7).encrypt(data!.bytes)
        } catch {
            
        }
        let encoded =  Data(encrypted)
        //加密结果要用Base64转码
        return encoded.base64EncodedString()
    }
    
    public static func encryptAes(strToEncode: String, aesKey: String) -> String {
        // 从String 转成data
        let data = strToEncode.data(using: String.Encoding.utf8)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {
            let privateKeyArr: [UInt8] = Array(aesKey.utf8)
            let aesIVArr: [UInt8] = Array(aesIV.utf8)
            encrypted = try AES(key: privateKeyArr, blockMode: CBC(iv: aesIVArr), padding: .pkcs7).encrypt(data!.bytes)
        } catch {
        }
        
        let encoded =  Data(encrypted)
        //加密结果要用Base64转码
        return encoded.base64EncodedString()
    }
    
    public static func decryptAes(strToDecode: String, aesKey: String) -> String {
        //decode base64
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        
        // 把data 转成byte数组
        for i in 0..<count! {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        do {
            let privateKeyArr: [UInt8] = Array(aesKey.utf8)
            let aesIVArr: [UInt8] = Array(aesIV.utf8)
            decrypted = try AES(key: privateKeyArr, blockMode: CBC(iv: aesIVArr), padding: .pkcs7).decrypt(encrypted)
        } catch {
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
    
}


