//
//  NetworkTool.swift
//  ShakeImage
//
//  Created by MacMini on 1/18/23.
//

import Foundation
import Moya

// NetworkAPI就是一个遵循TargetType协议的枚举
let NetworkProvider = MoyaProvider<NetworkAPI>()
let baseApiUrl = "https://api.t1y.net/v4/"

enum NetworkAPI {
    // 发送验证码
    case sendCode(params: [String: Any])
    // 验证验证码
    case verifyCode(params: [String: Any])
    // 注册账号
    case register(params: [String: Any])
    // 登录账号/获取用户信息
    case login(params: [String: Any])
    // 重置密码
    case resetPwd(params: [String: Any])
    // 修改昵称
    case rename(params: [String: Any])
    // 注销账号
    case regout(params: [String: Any])
    // 上传图片
    case publishImage(params: [String: Any])
    // 一般查询
    case select(params: [String: Any])
    // 修改
    case update(params: [String: Any])
    // 命令
    case sqlCommand(params: [String: Any])
}

extension NetworkAPI:TargetType {
    
    public var baseURL: URL{
        return URL(string: baseApiUrl)!
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .sendCode: return "sms/send_code"
        case .verifyCode: return "sms/code_verify"
        case .register: return "/app/register"
        case .login: return "app/login"
        case .resetPwd: return "app/forget"
        case .rename: return "app/rename"
        case .regout: return "app/cancel"
        case .publishImage: return "db/mysql/insert"
        case .select: return "db/mysql/select"
        case .update: return "db/mysql/update"
        case .sqlCommand: return "db/mysql/command"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .post
        /*
        switch self {
        case .sendCode, .verifyCode, .register, .login, .resetPwd, .rename, .regout, .publishImage:
            return .post
        }
         */
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .sendCode(let params), .verifyCode(let params), .register(let params), .login(let params), .resetPwd(let params), .rename(let params), .regout(let params), .publishImage(let params), .select(let params), .update(let params), .sqlCommand(let params):
            parmeters = params
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        }
    }
        
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 请求头
    public var headers: [String: String]? {
        return nil
    }
}
