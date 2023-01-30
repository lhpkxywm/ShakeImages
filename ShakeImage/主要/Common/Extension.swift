//
//  Extension.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let qiNiuFileHost = "http://kokofiles.waityousell.com/"
// 账户公钥
let tonePublicKey = "048e49f0305fb342be023c0d76cd6827"
// 账户私钥
let tonePrivateKey = "9cc4a79e3607bde250f037fb5dc0fd85"
// 数据接口公钥
let hostPublicAesKey = "e9f5e023b6e7bae1dea4212b1118340f"
// 数据接口私钥
let hostSecretAesKey = "55e34d63e78c9ad45dc97ee4907f0645"
// 应用公钥
let appPublicKey = "d854ce7ebf46bad5c85bdfd311f7c0d5"
// 应用私钥
let appPrivateKey = "a793011472d521e8dbe78fdb9f5e6519"
let aesIV = "t1ivk4o9t1ivk4o9"
let aesPadding = "pkcs7padding"

var Color_Theme: UIColor {
    return UIColor(named: "ThemeColor") ?? .systemBlue
}

var Color_Tab: UIColor {
    return UIColor(named: "TabColor") ?? .systemBlue
}

func isIPhoneXSeries() -> Bool {
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return false
    }
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
}

func dealResponseData(respData: Data, aesKey: String) -> [String: Any] {
    let respStr = String(data: respData, encoding: String.Encoding.utf8)
    let jsonStr = AesTool.decryptAes(strToDecode: respStr ?? "", aesKey: aesKey)
    let jsonData = jsonStr.data(using: String.Encoding.utf8)
    if let respDict = try? JSONSerialization.jsonObject(with: jsonData!) as? [String: Any] {
        return respDict
    } else {
        return [:]
    }
}
