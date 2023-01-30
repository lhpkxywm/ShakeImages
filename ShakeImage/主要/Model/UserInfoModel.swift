//
//  UserInfoModel.swift
//  ShakeImage
//
//  Created by MacMini on 1/20/23.
//

import Foundation
import HandyJSON

class UserInfoModel: HandyJSON {
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
    
    required init() {}
    
    public static var shared = UserInfoModel()
}
