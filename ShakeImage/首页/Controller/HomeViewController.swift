//
//  HomeViewController.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class HomeViewController: BaseProjController, UIScrollViewDelegate {
    
    var scrollIndex = 0
    var page = 0
    var hasLoad = false
    @IBOutlet weak var reportBarBtnItem: UIBarButtonItem!
    @IBOutlet weak var favorBarBtnItem: UIBarButtonItem!
    @IBOutlet weak var shareBarBtnItem: UIBarButtonItem!
    let contentLayout = TGLinearLayout(.horz)
    var dataArr: [ImageDataModel] = []
    var leftImgView = ImageScrollView()
    var centerImgView = ImageScrollView()
    var rightImgView = ImageScrollView()
    var currentImgModel: ImageDataModel? {
        didSet {
            guard let imgModel = currentImgModel else { return }
            if imgModel.isFavor {
                favorBarBtnItem.image = UIImage(systemName: "suit.heart.fill")
            } else {
                favorBarBtnItem.image = UIImage(systemName: "suit.heart")
            }
        }
    }
    var currentImgIndex = 0
    
    override func loadView() {
        super.loadView()
        let mainScrollView = UIScrollView()
        mainScrollView.isPagingEnabled = true
        mainScrollView.backgroundColor = UIColor(named: "BackColor")
        mainScrollView.delegate = self
        view = mainScrollView
        
        contentLayout.tg_width.equal(.wrap)
        contentLayout.tg_vertMargin(0)
        contentLayout.tg_gravity = TGGravity.vert.fill
        mainScrollView.addSubview(contentLayout)
        
        configScrollView()
    }
    
    func configScrollView() {
        leftImgView.tg_width.equal(screenWidth)
        contentLayout.addSubview(leftImgView)
        centerImgView.tg_width.equal(screenWidth)
        contentLayout.addSubview(centerImgView)
        rightImgView.tg_width.equal(screenWidth)
        contentLayout.addSubview(rightImgView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reportBarBtnItem.tintColor = .red
        favorBarBtnItem.tintColor = .red
        shareBarBtnItem.tintColor = .red
        let userDefault = UserDefaults.standard
        page = userDefault.value(forKey: "homePage") as? Int ?? 0
        loadNetworkData()
        
    }
    
    // MARK: - 请求数据
    func loadNetworkData() {
        var params = [String: Any]()
        params["key"] = hostPublicAesKey
        let jsonDict = [
            "table": "t_image",
            "column": "*",
            "where": "1",
            "sort": "desc LIMIT \(page*10),10",            // 排序（asc为升序a-z，desc为降序z-a）
            "sort_column": "imageId",
            "timestamp": Int(Date().timeIntervalSince1970)
        ] as [String : Any]
        let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: hostSecretAesKey)
        params["data"] = aesJsonStr
        let signature = (hostPublicAesKey + aesJsonStr + hostSecretAesKey).md5()
        params["signature"] = signature
        
        NetworkProvider.request(NetworkAPI.select(params: params)) { [self] result in
            if case .success(let response) = result {
                let resultDict = dealResponseData(respData: response.data, aesKey: hostSecretAesKey)
                if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                    let strData = try? JSONSerialization.data(withJSONObject: resultDict, options: [])
                    let jsonStr = String(data: strData!, encoding: String.Encoding.utf8)
                    let resultImgArr = [ImageDataModel].deserialize(from: jsonStr, designatedPath: "data.data")!
                    let currentUserId = UserInfoModel.shared.account
                    
                    for resultImg in resultImgArr {
                        if var imgDataModel = resultImg {
                            // 收藏该图片的用户id
                            var imgFavorIdArr = [String]()
                            if imgDataModel.favorIdArr.count > 0 {
                                imgFavorIdArr = imgDataModel.favorIdArr.components(separatedBy: ",")
                            }
                            if currentUserId.count > 0, imgFavorIdArr.contains(currentUserId) {
                                imgDataModel.isFavor = true
                            }
                            dataArr.append(imgDataModel)
                            if hasLoad == false, dataArr.count > 3 {
                                leftImgView.imgDataModel = dataArr.first!
                                centerImgView.imgDataModel = dataArr[1]
                                rightImgView.imgDataModel = dataArr[2]
                                currentImgModel = dataArr.first
                                hasLoad = true
                            }
                        }
                    }
                } else {
                    let msg = resultDict["msg"] as? String
                    view.hud.showError(msg)
                }
            }
        }
    }
    @IBAction func reportBarAction(_ sender: UIBarButtonItem) {
        if UserInfoModel.shared.account.count > 0 {
            guard var currentModel = currentImgModel else { return }
            let alertController = UIAlertController(title: "操作提示", message: "请选择图片令您厌恶的理由", preferredStyle: .actionSheet)
            let noFunnyAction = UIAlertAction(title: "不感兴趣🙁", style: .default) { _ in
                self.requestShield(imgModel: &currentModel, reason: 1)
            }
            alertController.addAction(noFunnyAction)
            let sexAction = UIAlertAction(title: "色情低俗😍", style: .default) { _ in
                self.requestShield(imgModel: &currentModel, reason: 2)
            }
            alertController.addAction(sexAction)
            let scarySickAction = UIAlertAction(title: "恐怖恶心🤮", style: .default) { _ in
                self.requestShield(imgModel: &currentModel, reason: 3)
            }
            alertController.addAction(scarySickAction)
            /*
            let userAction = UIAlertAction(title: "屏蔽该用户👦🏻", style: .default) { _ in
                self.requestShield(imgModel: &currentModel, reason: 4)
            }
            alertController.addAction(userAction)
             */
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                
            }
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
            present(alertController, animated: true) {
                
            }
        } else {
            view.hud.delay = 2
            view.hud.showInfo("请先登录")
            let loginVC = LoginViewController(isPresent: true)
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.navigationBar.barTintColor = Color_Theme
            loginNav.navigationBar.tintColor = .white
            loginNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            present(loginNav, animated: true, completion: nil)
        }
    }
    
    @IBAction func favorBarAction(_ sender: UIBarButtonItem) {
        view.hud.delay = 2
        if UserInfoModel.shared.account.count > 0 {
            guard var currentModel = currentImgModel else { return }
            if currentModel.isFavor == true {
                requestFavor(imgModel: &currentModel, status: false)
            } else {
                requestFavor(imgModel: &currentModel, status: true)
            }
        } else {
            view.hud.showInfo("请先登录")
            let loginVC = LoginViewController(isPresent: true)
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.navigationBar.barTintColor = Color_Theme
            loginNav.navigationBar.tintColor = .white
            loginNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            present(loginNav, animated: true, completion: nil)
        }
    }
    
    // MARK: - 分享图片
    @IBAction func shareBarAction(_ sender: UIBarButtonItem) {
        var shareImg: UIImage!
        switch currentImgIndex {
        case 0:
            shareImg = leftImgView.imageView.image
        case 1:
            shareImg = centerImgView.imageView.image
        default:
            shareImg = rightImgView.imageView.image
        }
        let shareText = "抖图，无声的抖音"
        let activityVC = UIActivityViewController(activityItems: [shareText, shareImg ?? ""], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 小于等于3个，不用处理
        if dataArr.count <= 3 {
            return
        }
        /*
        if scrollIndex > 3, scrollIndex % 10 == 0 {
            print("显示广告")
        }*/
        let contentOffSetX = scrollView.contentOffset.x
        // print("contentOffSetX=\(contentOffSetX),screenWidth=\(screenWidth),scrollIndex=\(scrollIndex)")
        // 向前滑到第一个
        if scrollIndex == 0, contentOffSetX <= 0 {
            print("从第一个开始向前滑，不管")
            return;
        }
        if scrollIndex == 0, contentOffSetX > 0, contentOffSetX <= screenWidth {
            print("从第一个开始向后滑")
            currentImgModel = leftImgView.imgDataModel
            currentImgIndex = 1
            return;
        }
        // 向后滑到最后一个
        if scrollIndex == dataArr.count - 1 && contentOffSetX > screenWidth {
            print("向后滑到最后一个")
            currentImgModel = rightImgView.imgDataModel
            currentImgIndex = 2
            page = 0
            let userDefault = UserDefaults.standard
            userDefault.setValue(page, forKey: "homePage")
            userDefault.synchronize()
            loadNetworkData()
            return;
        }
        // 判断是从中间视图从左向右滑(上一个)还是从右向左滑(下一个)
        if contentOffSetX >= screenWidth * 2 {
            // 从右向左滑(往后滑)
            print("从中间向后滑")
            if scrollIndex == 0 {
                scrollIndex += 2
                scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                leftImgView.imgDataModel = centerImgView.imgDataModel
                centerImgView.imgDataModel = rightImgView.imgDataModel
            } else {
                scrollIndex += 1
                if scrollIndex == dataArr.count - 1 {
                    centerImgView.imgDataModel = dataArr.last!
                } else {
                    scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                    leftImgView.imgDataModel = centerImgView.imgDataModel
                    centerImgView.imgDataModel = rightImgView.imgDataModel
                }
            }
            if scrollIndex < dataArr.count - 1 {
                rightImgView.imgDataModel = dataArr[scrollIndex + 1]
            }
        } else if contentOffSetX <= 0 {
            // 从左向右滑(往前滑)
            print("从中间向前滑")
            if scrollIndex == 1 {
                leftImgView.imgDataModel = dataArr[scrollIndex - 1]
                centerImgView.imgDataModel = dataArr[scrollIndex]
                rightImgView.imgDataModel = dataArr[scrollIndex + 1]
                scrollIndex = 0
                currentImgIndex = 0
                return;
            } else {
                /*
                if scrollIndex == dataArr.count - 1 {
                    scrollIndex -= 2
                } else {
                    scrollIndex -= 1
                }*/
                scrollIndex -= 1
                scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                rightImgView.imgDataModel = centerImgView.imgDataModel
                centerImgView.imgDataModel = leftImgView.imgDataModel
                
                if scrollIndex > 0 {
                    leftImgView.imgDataModel = dataArr[scrollIndex - 1]
                }
            }
        }
        // 只要是从中间向两侧滑动，currentImgIndex都赋值为1
        currentImgIndex = 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == screenWidth && scrollIndex == 0 {
            // 修正滑动的索引。当首次滑动一个屏幕宽时，索引=1
            scrollIndex = 1
        }
        // 当只剩最后两个的时候，获取新数据
        if scrollIndex == dataArr.count - 2 {
            // page = scrollIndex / 10 + 1
            page += 1
            print("page=\(page)")
            let userDefault = UserDefaults.standard
            userDefault.setValue(page, forKey: "homePage")
            userDefault.synchronize()
            loadNetworkData()
        }
        if scrollIndex < dataArr.count {
            currentImgModel = dataArr[scrollIndex]
        } else {
            print("图片加载缓慢!")
        }
        // print("scrollIndex=\(scrollIndex),imgIndex=\(currentImgIndex),dataArrCount=\(dataArr.count)")
    }
    // MARK: - 屏蔽图片请求
    func requestShield(imgModel: inout ImageDataModel, reason: Int) {
        // 获取当前登录用户
        let currentUserId = UserInfoModel.shared.account
        if currentUserId.count > 0 {
            view.hud.delay = 3
            // 获取厌恶该图片的用户id数组
            var shieldArr = [String]()
            if imgModel.shieldArr.count > 0 {
                shieldArr = imgModel.shieldArr.components(separatedBy: ",")
            } else {
                shieldArr = []
            }
            // 如果厌恶该图片的用户id数组中包含当前用户的id
            if shieldArr.contains(currentUserId) {
                print("查询数据异常，查询出了厌恶的图片")
            } else {
                shieldArr.append(currentUserId)
            }
            imgModel.shieldArr = shieldArr.joined(separator: ",")
            
            var params = [String: Any]()
            params["key"] = hostPublicAesKey
            let jsonDict = [
                "table": "t_image",
                "set": "shieldArr=\(imgModel.shieldArr)",
                "where": "imageId=\(imgModel.imageId)",
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: hostSecretAesKey)
            params["data"] = aesJsonStr
            let signature = (hostPublicAesKey + aesJsonStr + hostSecretAesKey).md5()
            params["signature"] = signature
            NetworkProvider.request(NetworkAPI.update(params: params)) { [self] result in
                if case .success(let response) = result {
                    let resultDict = dealResponseData(respData: response.data, aesKey: hostSecretAesKey)
                    if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                        switch reason {
                        case 1:
                            view.hud.showInfo("下次启动后您将不会看到此图片")
                        case 2:
                            view.hud.showInfo("下次启动后您将不会看到类似内容")
                        case 3:
                            view.hud.showInfo("下次启动后您将不会看到类似内容")
                        default:
                            break
                        }
                    } else {
                        view.hud.showError("请求失败!")
                    }
                }
            }
        }
        /*
        if reason < 4 {
            
        } else {
            // 将图片作者加入黑名单
            let authorId: String = imgObj.object(forKey: "authorId") as? String ?? ""
            if authorId != "" {
                // 获取当前用户的黑名单数组
                var filterIdArr = shieldUser.object(forKey: "filterIdArr") as? [String] ?? []
                // 在黑名单中添加图片作者的objId
                filterIdArr.append(authorId)
                // 覆盖并更新黑名单数据
                shieldUser.setObject(filterIdArr, forKey: "filterIdArr")
                shieldUser.updateInBackground(resultBlock: { [self] result, error in
                    if result {
                        view.hud.showInfo("此用户已进入您的黑名单，程序下次启动后您将不会看到该用户发布的任何图片")
                    } else {
                        view.hud.showError("请求失败!")
                    }
                })
            }
        }
         */
    }
    // MARK: - 收藏图片请求
    func requestFavor(imgModel: inout ImageDataModel, status: Bool) {
        // 获取当前登录用户
        let currentUserId = UserInfoModel.shared.account
        if currentUserId.count > 0 {
            view.hud.delay = 3
            // 获取收藏该图片的用户id数组
            var favorIdArr = [String]()
            if imgModel.favorIdArr.count > 0 {
                favorIdArr = imgModel.favorIdArr.components(separatedBy: ",")
            } else {
                favorIdArr = []
            }
            if status == true {
                favorIdArr.append(currentUserId)
            } else {
                favorIdArr.removeAll{
                    $0 == currentUserId
                }
            }
            if favorIdArr.count > 1 {
                imgModel.favorIdArr = favorIdArr.joined(separator: ",")
            } else {
                imgModel.favorIdArr = currentUserId
            }
            var params = [String: Any]()
            params["key"] = hostPublicAesKey
            let jsonDict = [
                "table": "t_image",
                "set": "favorIdArr='\(imgModel.favorIdArr)'",
                "where": "imageId='\(imgModel.imageId)'",
                "timestamp": Int(Date().timeIntervalSince1970)
            ] as [String : Any]
            let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: hostSecretAesKey)
            params["data"] = aesJsonStr
            let signature = (hostPublicAesKey + aesJsonStr + hostSecretAesKey).md5()
            params["signature"] = signature
            NetworkProvider.request(NetworkAPI.update(params: params)) { [self] result in
                if case .success(let response) = result {
                    let resultDict = dealResponseData(respData: response.data, aesKey: hostSecretAesKey)
                    if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                        if status == true {
                            view.hud.showSuccess("收藏成功!")
                            currentImgModel?.isFavor = true
                            dataArr[scrollIndex].isFavor = true
                            favorBarBtnItem.image = UIImage(systemName: "suit.heart.fill")
                        } else {
                            view.hud.showSuccess("已取消收藏!")
                            currentImgModel?.isFavor = false
                            dataArr[scrollIndex].isFavor = false
                            favorBarBtnItem.image = UIImage(systemName: "suit.heart")
                        }
                    } else {
                        view.hud.showError("请求失败!")
                    }
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

