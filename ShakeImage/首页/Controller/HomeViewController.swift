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
        mainScrollView.contentInsetAdjustmentBehavior = .never
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
        
        let imgQuery: BmobQuery = BmobQuery(className: "t_image")
        imgQuery.limit = 10
        imgQuery.skip = 10 * page
        if let currentUser = BmobUser.current() {
            // 当前用户黑名单数组
            let filterIdArr = currentUser.object(forKey: "filterIdArr") as? [String] ?? []
            // 屏蔽黑名单用户图片
            imgQuery.whereKey("author", notContainedIn: filterIdArr)
            // 屏蔽图片厌恶id中包含当前用户id的数据
            imgQuery.whereKey("shieldArr", notContainedIn: [currentUser.objectId!])
        }
        imgQuery.findObjectsInBackground { [self] resultArr, error in
            for i in 0..<resultArr!.count {
                let queryObj = resultArr![i] as! BmobObject
                let imgUrl = queryObj.object(forKey: "imageUrl") as! String
                var imgModel = ImageDataModel(imgUrl: imgUrl, isFavor: false, bmobObj: queryObj)
                if let userObjId = BmobUser.current()?.objectId {
                    let objIdArr: [String] = queryObj.object(forKey: "favorIdArr") as? [String] ?? []
                    if objIdArr.contains(userObjId) {
                        imgModel.isFavor = true
                    } else {
                        imgModel.isFavor = false
                    }
                }
                dataArr.append(imgModel)
            }
            if hasLoad == false, dataArr.count > 3 {
                leftImgView.imgDataModel = dataArr.first!
                centerImgView.imgDataModel = dataArr[1]
                rightImgView.imgDataModel = dataArr[2]
                currentImgModel = dataArr.first
                hasLoad = true
            }
        }
    }
    @IBAction func reportBarAction(_ sender: UIBarButtonItem) {
        if BmobUser.current() != nil {
            guard let currentModel = currentImgModel else { return }
            let alertController = UIAlertController(title: "操作提示", message: "请选择图片令您厌恶的理由", preferredStyle: .actionSheet)
            let noFunnyAction = UIAlertAction(title: "不感兴趣🙁", style: .default) { _ in
                // self.
                self.requestShield(imgObj: currentModel.bmobObj, reason: 1)
            }
            alertController.addAction(noFunnyAction)
            let sexAction = UIAlertAction(title: "色情低俗😍", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 2)
            }
            alertController.addAction(sexAction)
            let scarySickAction = UIAlertAction(title: "恐怖恶心🤮", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 3)
            }
            alertController.addAction(scarySickAction)
            let userAction = UIAlertAction(title: "屏蔽该用户👦🏻", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 4)
            }
            alertController.addAction(userAction)
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
        if BmobUser.current() != nil {
            guard let currentModel = currentImgModel else { return }
            if currentModel.isFavor == true {
                requestFavor(imgObj: currentModel.bmobObj, status: false)
            } else {
                requestFavor(imgObj: currentModel.bmobObj, status: true)
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
        let contentOffSetX = scrollView.contentOffset.x
        // 向前滑到第一个
        if scrollIndex == 0 && contentOffSetX <= screenWidth {
            currentImgModel = leftImgView.imgDataModel
            currentImgIndex = 0
            return;
        }
        // 向后滑到最后一个
        if scrollIndex == dataArr.count - 1 && contentOffSetX > screenWidth {
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
            if scrollIndex == 1 {
                leftImgView.imgDataModel = dataArr[scrollIndex - 1]
                centerImgView.imgDataModel = dataArr[scrollIndex]
                rightImgView.imgDataModel = dataArr[scrollIndex + 1]
                scrollIndex -= 1
            } else {
                if scrollIndex == dataArr.count - 1 {
                    scrollIndex -= 2
                } else {
                    scrollIndex -= 1
                }
                scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                rightImgView.imgDataModel = centerImgView.imgDataModel
                centerImgView.imgDataModel = leftImgView.imgDataModel
                
                if scrollIndex > 0 {
                    leftImgView.imgDataModel = dataArr.last!
                }
            }
        }
        currentImgIndex = 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == screenWidth && scrollIndex == 0 {
            // 修正滑动的索引。当首次滑动一个屏幕宽时，索引=1
            scrollIndex = 1
        }
        // 当只剩最后两个的时候，获取新数据
        print("scrollIndex=\(scrollIndex)")
        if scrollIndex == dataArr.count - 2 {
            // page = scrollIndex / 10 + 1
            page += 1
            print("page=\(page)")
            let userDefault = UserDefaults.standard
            userDefault.setValue(page, forKey: "homePage")
            userDefault.synchronize()
            loadNetworkData()
        }
        currentImgModel = dataArr[scrollIndex]
    }
    // MARK: - 屏蔽图片请求
    func requestShield(imgObj: BmobObject, reason: Int) {
        // 获取当前登录用户
        guard let shieldUser = BmobUser.current() else { return }
        view.hud.delay = 3
        if reason < 4 {
            // 获取厌恶该图片的用户id数组
            var shieldArr: [String] = imgObj.object(forKey: "shieldArr") as? [String] ?? []
            // 如果厌恶该图片的用户id数组中包含当前用户的id
            if shieldArr.contains(shieldUser.objectId) {
                print("查询数据异常，查询出了厌恶的图片")
            } else {
                shieldArr.append(shieldUser.objectId)
            }
            // 保存文件数据
            imgObj.setObject(shieldArr, forKey: "shieldArr")
            imgObj.updateInBackground { [self] result, error in
                if result {
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
    }
    // MARK: - 收藏图片请求
    func requestFavor(imgObj: BmobObject, status: Bool) {
        view.hud.delay = 2
        var favorIdArr: [String] = imgObj.object(forKey: "favorIdArr") as? [String] ?? []
        if status == true {
            if let userObjId = BmobUser.current().objectId {
                favorIdArr.append(userObjId)
            }
        } else {
            if let userObjId = BmobUser.current().objectId {
                favorIdArr.removeAll{
                    $0 == userObjId
                }
            }
        }
        imgObj.setObject(favorIdArr, forKey: "favorIdArr")
        imgObj.updateInBackground { [self] result, error in
            if result {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

