//
//  AppleLoginManager.swift
//  ShakeImage
//
//  Created by MacMini on 2021/5/13.
//

import Foundation
import AuthenticationServices

typealias AppleLoginSuccessClosure = (_ userId: String) -> Void
typealias AppleLoginFailClosure = (_ errStr: String) -> Void

class AppleLoginManager: NSObject {
    static let shared = AppleLoginManager()
    
    private weak var parentController: UIViewController?
    
    private var successComplete: AppleLoginSuccessClosure?
    private var failureComplete: AppleLoginFailClosure?
    
    public func isPast() -> Void {
        let provider = ASAuthorizationAppleIDProvider.init()
        provider.getCredentialState(forUserID: "") { status, error in
            switch status {
            case .revoked:
                print("已撤销")
            case .authorized:
                print("已授权")
            case .notFound:
                print("未发现")
            case .transferred:
                print("已转移")
            default:
                break
            }
        }
    }
    
    public func show(success: AppleLoginSuccessClosure? = nil, failure: AppleLoginFailClosure? = nil) {
        self.successComplete = success
        self.failureComplete = failure
        let provider = ASAuthorizationAppleIDProvider.init()
        let request = provider.createRequest()
        let controller = ASAuthorizationController.init(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows[0]
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let errorCode = Int.init(error._code)
        var errStr = ""
        switch errorCode {
        case ASAuthorizationError.Code.canceled.rawValue:
            errStr = "取消授权"
            print("取消授权")
        case ASAuthorizationError.Code.failed.rawValue:
            errStr = "授权请求失败"
            print("授权请求失败")
        case ASAuthorizationError.Code.invalidResponse.rawValue:
            errStr = "授权请求响应无效"
            print("授权请求响应无效")
        case ASAuthorizationError.Code.notHandled.rawValue:
            errStr = "未能处理授权请求"
            print("未能处理授权请求")
        default:
            errStr = "授权失败"
            print("授权失败")
        }
        self.failureComplete?(errStr)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if authorization.credential is ASAuthorizationAppleIDCredential {   // 登录
            let credential = authorization.credential as! ASAuthorizationAppleIDCredential
            let userId = credential.user
            print("user=\(userId)")
            
            guard let identityToken = credential.identityToken else {
                self.failureComplete?("identityToken为空")
                return
            }
            guard let token = String.init(data: identityToken, encoding: .utf8) else {
                self.failureComplete?("identityToken为空")
                return
            }
            self.successComplete?(userId)
        }
        else if authorization.credential is ASPasswordCredential {  // 使用现有的iCloud密钥链凭证登录。
            /*
            let credential = authorization.credential as! ASPasswordCredential
            let user = credential.user
            let password = credential.password
             */
            print("授权失败")
            self.failureComplete?("授权失败")
        }
        else {
            print("授权失败")
            self.failureComplete?("授权失败")
        }
    }
}
