//
//  MeViewController.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class MeViewController: BaseProjController, UITableViewDataSource, UITableViewDelegate {
    
    let unLoginLayout = TGLinearLayout(.vert)
    let tableView = UITableView()
    let logoutBtn = UIButton()
    lazy var dataArr: [MeItemModel] = {
        var modelArr = [MeItemModel]()
        let userPwdModel = MeItemModel(iconImage: "password", title: "修改密码", detail: "", vcName: "UpdatePasswordController")
        modelArr.append(userPwdModel)
        let uploadModel = MeItemModel(iconImage: "upload", title: "我上传的", detail: "", vcName: "MyUploadImageController")
        modelArr.append(uploadModel)
        let favorModel = MeItemModel(iconImage: "favor", title: "我喜爱的", detail: "", vcName: "MyFavorController")
        modelArr.append(favorModel)
        let filterModel = MeItemModel(iconImage: "blackList", title: "我的黑名单", detail: "", vcName: "MyFilterUserController")
        modelArr.append(filterModel)
        let clearShieldModel = MeItemModel(iconImage: "favor", title: "清除厌恶记录", detail: "", vcName: "")
        modelArr.append(clearShieldModel)
        let aboutModel = MeItemModel(iconImage: "aboutApp", title: "关于我们", detail: "", vcName: "AboutAppController")
        modelArr.append(aboutModel)
        return modelArr
    }()
    
    override func loadView() {
        super.loadView()
        tableView.tg_top.equal(0)
        tableView.tg_horzMargin(8)
        tableView.tg_height.equal(dataArr.count * 44)
        tableView.dataSource = self
        tableView.delegate = self
        frameLayout.addSubview(tableView)
        
        logoutBtn.tg_bottom.equal(20)
        logoutBtn.tg_horzMargin(20)
        logoutBtn.tg_height.equal(44)
        logoutBtn.layer.cornerRadius = 4
        logoutBtn.layer.masksToBounds = true
        logoutBtn.backgroundColor = Color_Theme
        logoutBtn.setTitleColor(.white, for: .normal)
        logoutBtn.titleLabel?.font = .systemFont(ofSize: 15)
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick), for: .touchUpInside)
        frameLayout.addSubview(logoutBtn)
        
        unLoginLayout.tg_centerX.equal(0)
        unLoginLayout.tg_top.equal(screenWidth/3)
        unLoginLayout.tg_horzMargin(40)
        unLoginLayout.tg_height.equal(.wrap)
        unLoginLayout.tg_gravity = .horz.center
        frameLayout.addSubview(unLoginLayout)
        /*
        let errIconView = UIImageView(image: UIImage(named: "unLogin"))
        errIconView.tg_top.equal(0)
        errIconView.tg_height.equal(errIconView.tg_width).multiply(1)
        unLoginLayout.addSubview(errIconView)*/
        
        let errLabel = UILabel()
        errLabel.tg_top.equal(0)
        errLabel.tg_horzMargin(0)
        errLabel.tg_height.equal(40)
        errLabel.textAlignment = .center
        errLabel.font = .systemFont(ofSize: 15)
        
        let attrStr = NSMutableAttributedString(string: "您还未登录，请登录")
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.label], range: NSRange(location: 0, length: 6))
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemBlue], range: NSRange(location: 6, length: 3))
        errLabel.attributedText = attrStr
        unLoginLayout.addSubview(errLabel)
        
        let loginBtn = UIButton()
        loginBtn.tg_top.equal(20)
        loginBtn.tg_horzMargin(40)
        loginBtn.tg_height.equal(40)
        loginBtn.layer.borderWidth = 0.5
        loginBtn.layer.borderColor = UIColor.systemBlue.cgColor
        loginBtn.layer.cornerRadius = 4
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(.systemBlue, for: .normal)
        loginBtn.titleLabel?.font = .systemFont(ofSize: 15)
        loginBtn.setTitle("账号密码登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        unLoginLayout.addSubview(loginBtn)
        
        let appleBtn = UIButton()
        appleBtn.tg_top.equal(20)
        appleBtn.tg_horzMargin(40)
        appleBtn.tg_height.equal(40)
        appleBtn.layer.borderWidth = 0.5
        appleBtn.layer.borderColor = UIColor.label.cgColor
        appleBtn.layer.cornerRadius = 4
        appleBtn.layer.masksToBounds = true
        appleBtn.backgroundColor = .clear
        appleBtn.setTitleColor(.label, for: .normal)
        appleBtn.titleLabel?.font = .systemFont(ofSize: 15)
        appleBtn.setTitle("使用AppleID登录", for: .normal)
        appleBtn.addTarget(self, action: #selector(appleLoginClick), for: .touchUpInside)
        unLoginLayout.addSubview(appleBtn)
        
        let policyBtn = UIButton()
        policyBtn.tg_top.equal(40)
        policyBtn.tg_horzMargin(0)
        policyBtn.tg_height.equal(40)
        policyBtn.setTitleColor(.systemBlue, for: .normal)
        policyBtn.titleLabel?.font = .systemFont(ofSize: 15)
        policyBtn.setTitle("点击阅读《用户服务协议及隐私政策》", for: .normal)
        policyBtn.addTarget(self, action: #selector(policyBtnClick), for: .touchUpInside)
        unLoginLayout.addSubview(policyBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BmobUser.current() != nil {
            tableView.isHidden = false
            logoutBtn.isHidden = false
            unLoginLayout.isHidden = true
        } else {
            tableView.isHidden = true
            logoutBtn.isHidden = true
            unLoginLayout.isHidden = false
        }
    }
    
    @objc func policyBtnClick() {
        let policyController = WebViewController("http://dnmfiles.waityousell.com/2020/11/20/ed921cb940587591801974c2ad649da3.html")
        navigationController?.pushViewController(policyController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MeItemCell"
        var meItemCell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if meItemCell == nil {
            meItemCell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            meItemCell?.selectionStyle = .none
            meItemCell?.accessoryType = .disclosureIndicator
        }
        let meItemModel = dataArr[indexPath.row]
        meItemCell?.imageView?.image = UIImage(named: meItemModel.iconImage)
        meItemCell?.textLabel?.text = meItemModel.title
        return meItemCell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let clickModel = dataArr[indexPath.row]
        let vcName = clickModel.vcName
        let vcClass = NSClassFromString(vcName) as! BaseProjController.Type
        let vc = vcClass.init()
        navigationController?.pushViewController(vc, animated: true)
         */
        switch indexPath.row {
        case 0:
            let updatePwdVC = UpdatePasswordController()
            updatePwdVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(updatePwdVC, animated: true)
        case 1:
            let uploadImgVC = MyUploadImageController()
            uploadImgVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(uploadImgVC, animated: true)
        case 2:
            let myFavorVC = MyFavorController()
            myFavorVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myFavorVC, animated: true)
        case 3:
            let myFilterVC = MyFilterUserController()
            myFilterVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myFilterVC, animated: true)
        case 4:
            requestClearShieldRecord()
        default:
            let aboutAppVC = AboutAppController()
            aboutAppVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(aboutAppVC, animated: true)
            break
        }
    }
    // MARK: - 登录按钮被点击
    @objc func loginBtnClick() {
        let loginVC = LoginViewController(isPresent: true)
        loginVC.resultClosure = { [self]
            (result) in
            if result {
                view.hud.showSuccess("登陆成功!")
                unLoginLayout.isHidden = true
                tableView.isHidden = false
                logoutBtn.isHidden = false
                tableView.reloadData()
            }
        }
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.navigationBar.barTintColor = Color_Theme
        loginNav.navigationBar.tintColor = .white
        loginNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.hud.showLoading("登录中")
        present(loginNav, animated: true, completion: nil)
    }
    // MARK: - 苹果ID登录
    @objc func appleLoginClick() {
        AppleLoginManager.shared.show { [self] userId in
            let userQuery = BmobUser.query()
            userQuery?.whereKey("appleIdInfo", equalTo: userId)
            userQuery?.findObjectsInBackground({ userArr,error in
                if userArr?.count ?? 0 > 0 {
                    let queryUser = userArr?.first as! BmobUser
                    queryUser.password = "appuser"
                    loginWith(bUser: queryUser)
                } else {
                    // 注册并直接登录
                    let registUser = BmobUser()
                    registUser.username = "user_" + userId
                    registUser.password = "appuser"
                    registUser.setObject(userId, forKey: "appleIdInfo")
                    registUser.signUpInBackground { result, error in
                        if result {
                            self.view.hud.showSuccess("注册成功!")
                            // 注册后直接登录
                            loginWith(bUser: registUser)
                        } else {
                            self.view.hud.showError("注册失败!")
                        }
                    }
                }
            })
        } failure: { errStr in
            self.view.hud.delay = 2
            self.view.hud.showError(errStr)
        }
    }
    // MARK: - bmob登录
    func loginWith(bUser: BmobUser) {
        BmobUser.loginWithUsername(inBackground: bUser.username, password: bUser.password) { [self] bUser, error in
            if bUser != nil {
                view.hud.showSuccess("登录成功!")
                unLoginLayout.isHidden = true
                tableView.isHidden = false
                logoutBtn.isHidden = false
                tableView.reloadData()
            } else {
                view.hud.showError("登录失败!")
            }
        }
    }
    // MARK: - 清除厌恶记录
    func requestClearShieldRecord() {
        guard let currentUser = BmobUser.current() else { return }
        let alertController = UIAlertController(title: "操作提示", message: "是否清除厌恶记录?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            let imgQuery: BmobQuery = BmobQuery(className: "t_image")
            // 屏蔽图片厌恶id中包含当前用户id的数据
            imgQuery.whereKey("shieldArr", containedIn: [currentUser.objectId!])
            imgQuery.findObjectsInBackground { resultArr, error in
                guard let imgObjArr = resultArr else { return }
                for i in 0..<imgObjArr.count {
                    let queryObj = imgObjArr[i] as! BmobObject
                    // 所有图片的shieldArr删除当前用户的objId
                    var shieldArr = queryObj.object(forKey: "shieldArr") as? [String] ?? []
                    shieldArr.removeAll{
                        $0 == currentUser.objectId
                    }
                    queryObj.setObject(shieldArr, forKey: "shieldArr")
                    // 保存图片文件
                    queryObj.updateInBackground()
                    if i == imgObjArr.count - 1 {
                        self.view.hud.showSuccess("清除成功!")
                    }
                }
            }
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 退出登录
    @objc func logoutBtnClick() {
        BmobUser.logout()
        view.hud.delay = 2
        view.hud.showSuccess("退出登录成功！")
        unLoginLayout.isHidden = false
        tableView.isHidden = true
        logoutBtn.isHidden = true
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
