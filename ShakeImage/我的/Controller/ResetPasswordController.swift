//
//  ResetPasswordController.swift
//  ShakeImage
//
//  Created by MacMini on 1/20/23.
//

import UIKit

class ResetPasswordController: BaseProjController {
    
    let contentLayout = TGLinearLayout(.vert)
    let codeTF = UITextField()
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
        
        let codeLayout = TGLinearLayout(.horz)
        codeLayout.tg_top.equal(24)
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
        passwordTF.borderStyle = .roundedRect
        passwordTF.placeholder = "请输入密码"
        passwordTF.isSecureTextEntry = true
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
        repeatPwdTF.borderStyle = .roundedRect
        repeatPwdTF.placeholder = "请再次输入密码"
        repeatPwdTF.isSecureTextEntry = true
        repeatPwdLayout.addSubview(repeatPwdTF)
        
        let resetPwdBtn = UIButton()
        resetPwdBtn.tg_top.equal(10)
        resetPwdBtn.tg_horzMargin(20)
        resetPwdBtn.tg_height.equal(44)
        resetPwdBtn.layer.borderWidth = 0.5
        resetPwdBtn.layer.borderColor = UIColor.systemBlue.cgColor
        resetPwdBtn.layer.cornerRadius = 5
        resetPwdBtn.layer.masksToBounds = true
        resetPwdBtn.setTitleColor(.systemBlue, for: .normal)
        resetPwdBtn.setTitle("重置密码", for: .normal)
        resetPwdBtn.addTarget(self, action: #selector(resetPwdBtnClick), for: .touchUpInside)
        contentLayout.addSubview(resetPwdBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "重置密码"
    }
    
    // 获取验证码
    @objc func codeBtnClick(clickBtn: UIButton) {
        var params = [String: Any]()
        params["key"] = tonePublicKey
        let jsonDict = [
            "mobile": UserInfoModel.shared.account,
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
    }
    
    @objc func resetPwdBtnClick() {
        view.hud.delay = 2
        guard let codeText = codeTF.text, codeText != "" else {
            view.hud.showError("验证码不能为空!")
            return
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
            var params = [String: Any]()
            params["key"] = appPublicKey
            let jsonDict = [
                "account": UserInfoModel.shared.account,
                "password": password,
                "code": codeText,
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: appPrivateKey)
            params["data"] = aesJsonStr
            let signature = (appPublicKey + aesJsonStr + appPrivateKey).md5()
            params["signature"] = signature
            NetworkProvider.request(NetworkAPI.resetPwd(params: params)) { [self] result in
                if case .success(let response) = result {
                    let resultDict = dealResponseData(respData: response.data, aesKey: appPrivateKey)
                    if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                        // 密码重置成功
                        view.hud.showSuccess("密码重置成功!")
                        navigationController?.popViewController(animated: true)
                    } else {
                        let msg = resultDict["msg"] as? String
                        view.hud.showError(msg)
                    }
                } else {
                    view.hud.showError("密码重置失败!")
                }
            }
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
