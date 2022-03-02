//
//  RegistViewController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class RegistViewController: BaseProjController {
    
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
        
        let userNameLayout = TGLinearLayout(.horz)
        userNameLayout.tg_top.equal(24)
        userNameLayout.tg_height.equal(44)
        userNameLayout.tg_gravity = TGGravity.vert.center
        userNameLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(userNameLayout)
        
        let unHeadLabel = UILabel()
        unHeadLabel.tg_width.equal(80)
        unHeadLabel.tg_height.equal(.fill)
        if #available(iOS 13.0, *) {
            unHeadLabel.textColor = .label
        } else {
            unHeadLabel.textColor = .darkText
        }
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
        if #available(iOS 13.0, *) {
            pwdHeadLabel.textColor = .label
        } else {
            pwdHeadLabel.textColor = .darkText
        }
        pwdHeadLabel.textAlignment = .center
        pwdHeadLabel.text = "密码:"
        passwordLayout.addSubview(pwdHeadLabel)
        
        passwordTF.tg_width.equal(.fill)
        passwordTF.tg_height.equal(32)
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
        if #available(iOS 13.0, *) {
            rptPwdHeadLabel.textColor = .label
        } else {
            rptPwdHeadLabel.textColor = .darkText
        }
        rptPwdHeadLabel.text = "重复密码:"
        repeatPwdLayout.addSubview(rptPwdHeadLabel)
        
        repeatPwdTF.tg_width.equal(.fill)
        repeatPwdTF.tg_height.equal(32)
        repeatPwdTF.borderStyle = .roundedRect
        repeatPwdTF.placeholder = "请再次输入密码"
        repeatPwdLayout.addSubview(repeatPwdTF)
        
        let policyBtn = UIButton(type: .system)
        policyBtn.tg_top.equal(10)
        policyBtn.tg_height.equal(44)
        policyBtn.setTitle("《用户服务协议》", for: .normal)
        policyBtn.addTarget(self, action: #selector(policyBtnClick), for: .touchUpInside)
        contentLayout.addSubview(policyBtn)
        
        let registBtn = UIButton()
        registBtn.tg_top.equal(10)
        registBtn.tg_horzMargin(20)
        registBtn.tg_height.equal(44)
        registBtn.layer.borderWidth = 0.5
        registBtn.layer.borderColor = UIColor.systemBlue.cgColor
        registBtn.layer.cornerRadius = 5
        registBtn.layer.masksToBounds = true
        registBtn.setTitleColor(.systemBlue, for: .normal)
        registBtn.setTitle("注册", for: .normal)
        registBtn.addTarget(self, action: #selector(registBtnClick), for: .touchUpInside)
        contentLayout.addSubview(registBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "注册"
    }
    
    @objc func policyBtnClick() {
        let policyController = WebViewController("http://dnmfiles.waityousell.com/2020/11/20/ed921cb940587591801974c2ad649da3.html")
        navigationController?.pushViewController(policyController, animated: true)
    }
    
    @objc func registBtnClick() {
        view.hud.delay = 2
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
        if password.count < 6 {
            view.hud.showError("密码需至少为6位")
        }
        guard let rptPassword = repeatPwdTF.text, rptPassword != "" else {
            view.hud.showError("重复密码不能为空!")
            return
        }
        if password == rptPassword {
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
