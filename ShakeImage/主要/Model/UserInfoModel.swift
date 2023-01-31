//
//  UserInfoModel.swift
//  ShakeImage
//
//  Created by MacMini on 1/20/23.
//

import Foundation
import HandyJSON

class UserInfoModel: NSObject, NSSecureCoding, HandyJSON {
    /// 昵称
    var name = ""
    /// 账号
    var account = ""
    /// 积分
    var jf = ""
    /// 余额
    var money = ""
    /// 会员剩余天数
    var vip_day = ""
    /// 会员到期时间
    var vip_time = ""
    /// 注册时间
    var register_time = ""
    
    static let filePath: String = {
        let strPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let filePath = strPath.appendingPathComponent("userData.data")
        return filePath
    }()
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(account, forKey: "account")
        coder.encode(jf, forKey: "jf")
        coder.encode(money, forKey: "money")
        coder.encode(vip_day, forKey: "vip_day")
        coder.encode(vip_time, forKey: "vip_time")
        coder.encode(register_time, forKey: "register_time")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        account = coder.decodeObject(forKey: "account") as! String
        jf = coder.decodeObject(forKey: "jf") as! String
        money = coder.decodeObject(forKey: "money") as! String
        vip_day = coder.decodeObject(forKey: "vip_day") as! String
        vip_time = coder.decodeObject(forKey: "vip_time") as! String
        register_time = coder.decodeObject(forKey: "register_time") as! String
    }
    
    required override init() {
        
    }
    
    public static var shared = UserInfoModel()
}
