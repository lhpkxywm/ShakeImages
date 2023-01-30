//
//  RegistViewController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class RegistViewController: BaseProjController {
    let mobilePhoneTF = UITextField()
    let codeTF = UITextField()
    let userNameTF = UITextField()
    let passwordTF = UITextField()
    let repeatPwdTF = UITextField()
    
    override func loadView() {
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_insetsPaddingFromSafeArea = .all
        contentLayout.tg_insetLandscapeFringePadding = false
        contentLayout.tg_gravity = TGGravity.horz.fill
        contentLayout.tg_padding = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        contentLayout.backgroundColor = UIColor(named: "BackColor")
        view = contentLayout
        
        let mobilePhoneLayout = TGLinearLayout(.horz)
        mobilePhoneLayout.tg_top.equal(24)
        mobilePhoneLayout.tg_height.equal(44)
        mobilePhoneLayout.tg_gravity = TGGravity.vert.center
        mobilePhoneLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(mobilePhoneLayout)
        
        let mpHeadLabel = UILabel()
        mpHeadLabel.tg_width.equal(80)
        mpHeadLabel.tg_height.equal(.fill)
        mpHeadLabel.textColor = .label
        mpHeadLabel.text = "手机号:"
        mobilePhoneLayout.addSubview(mpHeadLabel)
        
        mobilePhoneTF.tg_width.equal(.fill)
        mobilePhoneTF.tg_height.equal(32)
        mobilePhoneTF.borderStyle = .roundedRect
        mobilePhoneTF.placeholder = "请输入手机号"
        mobilePhoneTF.keyboardType = .numberPad
        mobilePhoneLayout.addSubview(mobilePhoneTF)
        
        let codeLayout = TGLinearLayout(.horz)
        codeLayout.tg_height.equal(44)
        codeLayout.tg_gravity = TGGravity.vert.center
        codeLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(codeLayout)
        
        let codeHeadLabel = UILabel()
        codeHeadLabel.tg_width.equal(80)
        codeHeadLabel.tg_height.equal(.fill)
        codeHeadLabel.textColor = .label
        codeHeadLabel.text = "验证码:"
        codeLayout.addSubview(codeHeadLabel)
        
        codeTF.tg_width.equal(.fill)
        codeTF.tg_height.equal(32)
        codeTF.borderStyle = .roundedRect
        codeTF.placeholder = "请输入验证码"
        codeLayout.addSubview(codeTF)
        
        let codeBtn = UIButton()
        codeBtn.tg_left.equal(4)
        codeBtn.tg_width.equal(100)
        codeBtn.tg_height.equal(34)
        codeBtn.setTitleColor(.systemBlue, for: .normal)
        codeBtn.titleLabel?.font = .systemFont(ofSize: 15)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.addTarget(self, action: #selector(codeBtnClick), for: .touchUpInside)
        codeLayout.addSubview(codeBtn)
        
        let userNameLayout = TGLinearLayout(.horz)
        userNameLayout.tg_height.equal(44)
        userNameLayout.tg_gravity = TGGravity.vert.center
        userNameLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(userNameLayout)
        
        let unHeadLabel = UILabel()
        unHeadLabel.tg_width.equal(80)
        unHeadLabel.tg_height.equal(.fill)
        unHeadLabel.textColor = .label
        unHeadLabel.text = "用户名:"
        userNameLayout.addSubview(unHeadLabel)
        
        userNameTF.tg_width.equal(.fill)
        userNameTF.tg_height.equal(32)
        userNameTF.borderStyle = .roundedRect
        userNameTF.placeholder = "请输入用户名"
        userNameLayout.addSubview(userNameTF)
        
        let passwordLayout = TGLinearLayout(.horz)
        passwordLayout.tg_height.equal(44)
        passwordLayout.tg_gravity = TGGravity.vert.center
        passwordLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(passwordLayout)
        
        let pwdHeadLabel = UILabel()
        pwdHeadLabel.tg_width.equal(80)
        pwdHeadLabel.tg_height.equal(.fill)
        pwdHeadLabel.textColor = .label
        pwdHeadLabel.textAlignment = .center
        pwdHeadLabel.text = "密码:"
        passwordLayout.addSubview(pwdHeadLabel)
        
        passwordTF.tg_width.equal(.fill)
        passwordTF.tg_height.equal(32)
        passwordTF.isSecureTextEntry = true
        passwordTF.borderStyle = .roundedRect
        passwordTF.placeholder = "请输入密码"
        passwordLayout.addSubview(passwordTF)
        
        let repeatPwdLayout = TGLinearLayout(.horz)
        repeatPwdLayout.tg_height.equal(44)
        repeatPwdLayout.tg_gravity = TGGravity.vert.center
        repeatPwdLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(repeatPwdLayout)
        
        let rptPwdHeadLabel = UILabel()
        rptPwdHeadLabel.tg_width.equal(80)
        rptPwdHeadLabel.tg_height.equal(.fill)
        rptPwdHeadLabel.textColor = .label
        rptPwdHeadLabel.text = "重复密码:"
        repeatPwdLayout.addSubview(rptPwdHeadLabel)
        
        repeatPwdTF.tg_width.equal(.fill)
        repeatPwdTF.tg_height.equal(32)
        repeatPwdTF.isSecureTextEntry = true
        repeatPwdTF.borderStyle = .roundedRect
        repeatPwdTF.placeholder = "请再次输入密码"
        repeatPwdLayout.addSubview(repeatPwdTF)
        
        let policyBtn = UIButton(type: .system)
        policyBtn.tg_top.equal(10)
        policyBtn.tg_height.equal(44)
        policyBtn.setTitle("《用户服务协议》", for: .normal)
        policyBtn.addTarget(self, action: #selector(policyBtnClick), for: .touchUpInside)
        contentLayout.addSubview(policyBtn)
        
        let registerBtn = UIButton()
        registerBtn.tg_top.equal(10)
        registerBtn.tg_horzMargin(20)
        registerBtn.tg_height.equal(44)
        registerBtn.layer.borderWidth = 0.5
        registerBtn.layer.borderColor = UIColor.systemBlue.cgColor
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.masksToBounds = true
        registerBtn.setTitleColor(.systemBlue, for: .normal)
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        contentLayout.addSubview(registerBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "注册"
    }
    
    // 获取验证码
    @objc func codeBtnClick(clickBtn: UIButton) {
        if let mobilePhone = mobilePhoneTF.text, mobilePhone.count == 11 {
            var params = [String: Any]()
            params["key"] = tonePublicKey
            let jsonDict = [
                "mobile": mobilePhone,
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: tonePrivateKey)
            params["data"] = aesJsonStr
            let signature = (tonePublicKey + aesJsonStr + tonePrivateKey).md5()
            params["signature"] = signature
            NetworkProvider.request(NetworkAPI.sendCode(params: params)) { result in
                if case .success(let response) = result {
                    // 解密数据
                    let resultDict = dealResponseData(respData: response.data, aesKey: tonePrivateKey)
                    if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                        clickBtn.isEnabled = false
                        clickBtn.setTitleColor(.lightGray, for: .normal)
                        clickBtn.setTitle("已获取", for: .normal)
                    } else {
                        let msg = resultDict["msg"] as? String
                        UIApplication.shared.windows.first?.hud.showError(msg)
                    }
                } else {
                    print("failure")
                }
            }
        } else {
            UIApplication.shared.windows.first?.hud.showError("请输入正确的11位手机号!")
        }
    }
    
    @objc func policyBtnClick() {
        let policyController = WebViewController("http://dnmfiles.waityousell.com/2020/11/20/ed921cb940587591801974c2ad649da3.html")
        navigationController?.pushViewController(policyController, animated: true)
    }
    
    @objc func registerBtnClick() {
        view.hud.delay = 2
        guard let account = mobilePhoneTF.text, account != "" else {
            view.hud.showError("手机号不能为空")
            return
        }
        
        guard let codeText = codeTF.text, codeText != "" else {
            view.hud.showError("验证码不能为空!")
            return
        }
        
        guard let userName = userNameTF.text, userName != "" else {
            view.hud.showError("用户名不能为空!")
            return
        }
        if userName.count == 0 {
            view.hud.showError("用户名不能为空")
        }
        guard let password = passwordTF.text, password != "" else {
            view.hud.showError("密码不能为空!")
            return
        }
        if password.count < 6 || password.count > 16 {
            view.hud.showError("密码长度应为6~16位!")
        }
        guard let rptPassword = repeatPwdTF.text, rptPassword != "" else {
            view.hud.showError("重复密码不能为空!")
            return
        }
        if password == rptPassword {
            // 注册账号
            var params = [String: Any]()
            params["key"] = appPublicKey
            let jsonDict = [
                "name": userName,
                "account": account,
                "password": password,
                "code": codeText,
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: appPrivateKey)
            params["data"] = aesJsonStr
            let signature = (appPublicKey + aesJsonStr + appPrivateKey).md5()
            params["signature"] = signature
            NetworkProvider.request(NetworkAPI.register(params: params)) { result in
                if case .success(let response) = result {
                    // 解密数据
                    let resultDict = dealResponseData(respData: response.data, aesKey: appPrivateKey)
                    if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                        UIApplication.shared.windows.first?.hud.showError("注册成功!")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let msg = resultDict["msg"] as? String
                        UIApplication.shared.windows.first?.hud.showError(msg)
                    }
                }
            }
            
            /*
            let registUser = BmobUser()
            registUser.username = userName
            registUser.password = password
            registUser.signUpInBackground { result, error in
                if result {
                    self.view.hud.showSuccess("注册成功!")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.view.hud.showError("注册失败!")
                }
            }
             */
        } else {
            view.hud.showError("两次输入的密码不一致!")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
