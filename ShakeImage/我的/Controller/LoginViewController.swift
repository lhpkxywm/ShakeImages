//
//  LoginViewController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class LoginViewController: BaseProjController {
    
    var isPresent = false
    let contentLayout = TGLinearLayout(.vert)
    let userNameTF = UITextField()
    let passwordTF = UITextField()
    let loginBtn = UIButton()
    let updatePwdBtn = UIButton()
    let registerBtn = UIButton()
    var resultClosure: ((_ result: Bool) -> Void)?
    
    convenience init(isPresent: Bool) {
        self.init()
        self.isPresent = isPresent
    }
    
    override func loadView() {
        super.loadView()
        contentLayout.tg_margin(0)
        contentLayout.tg_padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        contentLayout.backgroundColor = UIColor(named: "BackColor")
        frameLayout.addSubview(contentLayout)
        
        let headImgView = UIImageView(image: UIImage(named: "AppIcon"))
        headImgView.tg_top.equal(20)
        headImgView.tg_centerX.equal(0)
        headImgView.tg_width.equal(100)
        headImgView.tg_height.equal(100)
        contentLayout.addSubview(headImgView)
        
        createUserNameLayout()
        createPasswordLayout()
        
        let loginBtn = UIButton()
        loginBtn.tg_top.equal(20)
        loginBtn.tg_horzMargin(0)
        loginBtn.tg_height.equal(44)
        loginBtn.layer.borderWidth = 0.5
        loginBtn.layer.borderColor = UIColor.systemBlue.cgColor
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(.systemBlue, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        contentLayout.addSubview(loginBtn)
        
        createBottomLayout()
    }
    
    func createUserNameLayout() {
        let userNameLayout = TGLinearLayout(.horz)
        userNameLayout.tg_top.equal(30)
        userNameLayout.tg_horzMargin(0)
        userNameLayout.tg_height.equal(42)
        userNameLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(userNameLayout)
        
        let mobileIconView = UIImageView(image: UIImage(named: "mobile"))
        mobileIconView.tg_centerY.equal(0)
        mobileIconView.tg_width.equal(16)
        mobileIconView.tg_height.equal(16)
        userNameLayout.addSubview(mobileIconView)
        
        userNameTF.tg_left.equal(8)
        userNameTF.tg_vertMargin(0)
        userNameTF.tg_width.equal(TGWeight(1))
        userNameTF.font = .systemFont(ofSize: 15)
        userNameTF.placeholder = "请输入用户名"
        userNameTF.clearButtonMode = .whileEditing
        userNameLayout.addSubview(userNameTF)
    }
    
    func createPasswordLayout() {
        let passwordLayout = TGLinearLayout(.horz)
        passwordLayout.tg_horzMargin(0)
        passwordLayout.tg_height.equal(42)
        passwordLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(passwordLayout)
        
        let pwdIconView = UIImageView(image: UIImage(named: "lock"))
        pwdIconView.tg_centerY.equal(0)
        pwdIconView.tg_width.equal(16)
        pwdIconView.tg_height.equal(16)
        passwordLayout.addSubview(pwdIconView)
        
        passwordTF.tg_left.equal(8)
        passwordTF.tg_vertMargin(0)
        passwordTF.tg_width.equal(TGWeight(1))
        passwordTF.font = .systemFont(ofSize: 15)
        passwordTF.placeholder = "请输入密码"
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.textContentType = .password
        passwordLayout.addSubview(passwordTF)
    }
    
    func createBottomLayout() {
        let bottomLayout = TGLinearLayout(.horz)
        bottomLayout.tg_horzMargin(20)
        bottomLayout.tg_bottom.equal(48)
        bottomLayout.tg_height.equal(32)
        bottomLayout.tg_gravity = TGGravity.vert.fill
        frameLayout.addSubview(bottomLayout)
        
        let updatePwdBtn = UIButton()
        updatePwdBtn.tg_width.equal(TGWeight(1))
        updatePwdBtn.setTitleColor(.systemBlue, for: .normal)
        updatePwdBtn.titleLabel?.font = .systemFont(ofSize: 15)
        updatePwdBtn.setTitle("修改密码", for: .normal)
        updatePwdBtn.addTarget(self, action: #selector(updatePwdBtnClick), for: .touchUpInside)
        bottomLayout.addSubview(updatePwdBtn)
        
        let registerBtn = UIButton()
        registerBtn.tg_width.equal(TGWeight(1))
        registerBtn.setTitleColor(.systemBlue, for: .normal)
        registerBtn.titleLabel?.font = .systemFont(ofSize: 15)
        registerBtn.setTitle("新用户注册", for: .normal)
        registerBtn.addTarget(self, action: #selector(registBtnClick), for: .touchUpInside)
        bottomLayout.addSubview(registerBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "登录"
    }
    
    @objc func loginBtnClick() {
        let userName = userNameTF.text
        let password = passwordTF.text
        view.hud.delay = 2
        if userName == "" {
            view.hud.showError("用户名不能为空")
            return
        }
        if password == "" {
            view.hud.showError("密码不能为空")
            return
        }
        view.hud.showLoading("登录中")
        BmobUser.loginWithUsername(inBackground: userName, password: password) { bUser, error in
            if bUser != nil {
                self.view.hud.dismiss()
                if self.isPresent {
                    self.dismiss(animated: true) {
                        self.resultClosure?(true)
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.view.hud.showError("登录失败!")
            }
        }
    }
    
    @objc func updatePwdBtnClick() {
        let updatePwdVC = UpdatePasswordController()
        navigationController?.pushViewController(updatePwdVC, animated: true)
    }
    
    @objc func registBtnClick() {
        let registerVC = RegistViewController()
        navigationController?.pushViewController(registerVC, animated: true)
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
