//
//  UpdatePasswordController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class UpdatePasswordController: BaseProjController {
    
    let contentLayout = TGLinearLayout(.vert)
    let oldPasswordTF = UITextField()
    let passwordTF = UITextField()
    let confirmPwdTF = UITextField()
    
    override func loadView() {
        super.loadView()
        contentLayout.tg_margin(0)
        frameLayout.addSubview(contentLayout)
        
        let oldPwdLayout = TGLinearLayout(.horz)
        oldPwdLayout.tg_horzMargin(20)
        oldPwdLayout.tg_height.equal(44)
        oldPwdLayout.tg_gravity = TGGravity.vert.center
        oldPwdLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(oldPwdLayout)
        
        let oldHeadLabel = UILabel()
        oldHeadLabel.tg_width.equal(100)
        oldHeadLabel.tg_height.equal(30)
        oldHeadLabel.textColor = .label
        oldHeadLabel.font = .systemFont(ofSize: 15)
        oldHeadLabel.text = "原密码"
        oldPwdLayout.addSubview(oldHeadLabel)
        
        oldPasswordTF.tg_width.equal(TGWeight(1))
        oldPasswordTF.tg_height.equal(44)
        oldPasswordTF.textColor = .label
        oldPasswordTF.font = .systemFont(ofSize: 15)
        oldPasswordTF.placeholder = "请输入旧密码"
        oldPasswordTF.isSecureTextEntry = true
        oldPwdLayout.addSubview(oldPasswordTF)
        
        let passwordLayout = TGLinearLayout(.horz)
        passwordLayout.tg_top.equal(6)
        passwordLayout.tg_horzMargin(20)
        passwordLayout.tg_height.equal(44)
        passwordLayout.tg_gravity = TGGravity.vert.center
        passwordLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(passwordLayout)
        
        let pwdHeadLabel = UILabel()
        pwdHeadLabel.tg_width.equal(100)
        pwdHeadLabel.tg_height.equal(30)
        pwdHeadLabel.textColor = .label
        pwdHeadLabel.font = .systemFont(ofSize: 15)
        pwdHeadLabel.text = "新密码"
        passwordLayout.addSubview(pwdHeadLabel)
        
        passwordTF.tg_width.equal(TGWeight(1))
        passwordTF.tg_height.equal(44)
        passwordTF.textColor = .label
        passwordTF.font = .systemFont(ofSize: 15)
        passwordTF.placeholder = "请输入新密码"
        passwordTF.isSecureTextEntry = true
        passwordLayout.addSubview(passwordTF)
        
        let confirmLayout = TGLinearLayout(.horz)
        confirmLayout.tg_top.equal(6)
        confirmLayout.tg_horzMargin(20)
        confirmLayout.tg_height.equal(44)
        confirmLayout.tg_gravity = TGGravity.vert.center
        confirmLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(confirmLayout)
        
        let confirmHeadLabel = UILabel()
        confirmHeadLabel.tg_width.equal(100)
        confirmHeadLabel.tg_height.equal(30)
        confirmHeadLabel.textColor = .label
        confirmHeadLabel.font = .systemFont(ofSize: 15)
        confirmHeadLabel.text = "重复密码"
        confirmLayout.addSubview(confirmHeadLabel)
        
        confirmPwdTF.tg_width.equal(TGWeight(1))
        confirmPwdTF.tg_height.equal(44)
        confirmPwdTF.textColor = .label
        confirmPwdTF.font = .systemFont(ofSize: 15)
        confirmPwdTF.placeholder = "请再次输入新密码"
        confirmPwdTF.isSecureTextEntry = true
        confirmLayout.addSubview(confirmPwdTF)
        
        let submitBtn = UIButton()
        submitBtn.tg_top.equal(20)
        submitBtn.tg_horzMargin(20)
        submitBtn.tg_height.equal(44)
        submitBtn.layer.borderWidth = 0.5
        submitBtn.layer.borderColor = UIColor.systemBlue.cgColor
        submitBtn.layer.cornerRadius = 22
        submitBtn.layer.masksToBounds = true
        submitBtn.setTitleColor(.systemBlue, for: .normal)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        contentLayout.addSubview(submitBtn)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "修改密码"
    }
    
    @objc func submitBtnClick() {
        view.hud.delay = 2
        if oldPasswordTF.text?.count == 0 {
            view.hud.showInfo("请输入旧密码")
            return
        }
        if passwordTF.text?.count == 0 {
            view.hud.showInfo("请输入新密码")
            return
        }
        if passwordTF.text != confirmPwdTF.text {
            view.hud.showError("两次输入的密码不一致")
            return
        }
        let bUser = BmobUser.current()
        bUser?.updateCurrentUserPassword(withOldPassword: oldPasswordTF.text, newPassword: passwordTF.text, block: { result, error in
            if result {
                self.view.hud.showSuccess("密码修改成功!")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.view.hud.showError("密码修改失败!")
            }
        })
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
