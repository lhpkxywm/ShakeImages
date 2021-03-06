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
    
    // MARK: - ????????????
    func loadNetworkData() {
        
        let imgQuery: BmobQuery = BmobQuery(className: "t_image")
        imgQuery.limit = 10
        imgQuery.skip = 10 * page
        if let currentUser = BmobUser.current() {
            // ???????????????????????????
            let filterIdArr = currentUser.object(forKey: "filterIdArr") as? [String] ?? []
            // ???????????????????????????
            imgQuery.whereKey("author", notContainedIn: filterIdArr)
            // ??????????????????id?????????????????????id?????????
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
            let alertController = UIAlertController(title: "????????????", message: "????????????????????????????????????", preferredStyle: .actionSheet)
            let noFunnyAction = UIAlertAction(title: "????????????????", style: .default) { _ in
                // self.
                self.requestShield(imgObj: currentModel.bmobObj, reason: 1)
            }
            alertController.addAction(noFunnyAction)
            let sexAction = UIAlertAction(title: "????????????????", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 2)
            }
            alertController.addAction(sexAction)
            let scarySickAction = UIAlertAction(title: "????????????????", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 3)
            }
            alertController.addAction(scarySickAction)
            let userAction = UIAlertAction(title: "???????????????????????", style: .default) { _ in
                self.requestShield(imgObj: currentModel.bmobObj, reason: 4)
            }
            alertController.addAction(userAction)
            let cancelAction = UIAlertAction(title: "??????", style: .cancel) { _ in
                
            }
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
            present(alertController, animated: true) {
                
            }
        } else {
            view.hud.delay = 2
            view.hud.showInfo("????????????")
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
            view.hud.showInfo("????????????")
            let loginVC = LoginViewController(isPresent: true)
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.navigationBar.barTintColor = Color_Theme
            loginNav.navigationBar.tintColor = .white
            loginNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            present(loginNav, animated: true, completion: nil)
        }
    }
    
    // MARK: - ????????????
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
        let shareText = "????????????????????????"
        let activityVC = UIActivityViewController(activityItems: [shareText, shareImg ?? ""], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // ????????????3??????????????????
        if dataArr.count <= 3 {
            return
        }
        /*
        if scrollIndex > 3, scrollIndex % 10 == 0 {
            print("????????????")
        }*/
        let contentOffSetX = scrollView.contentOffset.x
        // print("contentOffSetX=\(contentOffSetX),screenWidth=\(screenWidth),scrollIndex=\(scrollIndex)")
        // ?????????????????????
        if scrollIndex == 0, contentOffSetX <= 0 {
            print("????????????????????????????????????")
            return;
        }
        if scrollIndex == 0, contentOffSetX > 0, contentOffSetX <= screenWidth {
            print("???????????????????????????")
            currentImgModel = leftImgView.imgDataModel
            currentImgIndex = 1
            return;
        }
        // ????????????????????????
        if scrollIndex == dataArr.count - 1 && contentOffSetX > screenWidth {
            print("????????????????????????")
            currentImgModel = rightImgView.imgDataModel
            currentImgIndex = 2
            page = 0
            let userDefault = UserDefaults.standard
            userDefault.setValue(page, forKey: "homePage")
            userDefault.synchronize()
            loadNetworkData()
            return;
        }
        // ???????????????????????????????????????(?????????)?????????????????????(?????????)
        if contentOffSetX >= screenWidth * 2 {
            // ???????????????(?????????)
            print("??????????????????")
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
            // ???????????????(?????????)
            print("??????????????????")
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
        // ????????????????????????????????????currentImgIndex????????????1
        currentImgIndex = 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == screenWidth && scrollIndex == 0 {
            // ??????????????????????????????????????????????????????????????????=1
            scrollIndex = 1
        }
        // ????????????????????????????????????????????????
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
            print("??????????????????!")
        }
        // print("scrollIndex=\(scrollIndex),imgIndex=\(currentImgIndex),dataArrCount=\(dataArr.count)")
    }
    // MARK: - ??????????????????
    func requestShield(imgObj: BmobObject, reason: Int) {
        // ????????????????????????
        guard let shieldUser = BmobUser.current() else { return }
        view.hud.delay = 3
        if reason < 4 {
            // ??????????????????????????????id??????
            var shieldArr: [String] = imgObj.object(forKey: "shieldArr") as? [String] ?? []
            // ??????????????????????????????id??????????????????????????????id
            if shieldArr.contains(shieldUser.objectId) {
                print("????????????????????????????????????????????????")
            } else {
                shieldArr.append(shieldUser.objectId)
            }
            // ??????????????????
            imgObj.setObject(shieldArr, forKey: "shieldArr")
            imgObj.updateInBackground { [self] result, error in
                if result {
                    switch reason {
                    case 1:
                        view.hud.showInfo("??????????????????????????????????????????")
                    case 2:
                        view.hud.showInfo("?????????????????????????????????????????????")
                    case 3:
                        view.hud.showInfo("?????????????????????????????????????????????")
                    default:
                        break
                    }
                } else {
                    view.hud.showError("????????????!")
                }
            }
        } else {
            // ??????????????????????????????
            let authorId: String = imgObj.object(forKey: "authorId") as? String ?? ""
            if authorId != "" {
                // ????????????????????????????????????
                var filterIdArr = shieldUser.object(forKey: "filterIdArr") as? [String] ?? []
                // ????????????????????????????????????objId
                filterIdArr.append(authorId)
                // ??????????????????????????????
                shieldUser.setObject(filterIdArr, forKey: "filterIdArr")
                shieldUser.updateInBackground(resultBlock: { [self] result, error in
                    if result {
                        view.hud.showInfo("?????????????????????????????????????????????????????????????????????????????????????????????????????????")
                    } else {
                        view.hud.showError("????????????!")
                    }
                })
            }
        }
    }
    // MARK: - ??????????????????
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
                    view.hud.showSuccess("????????????!")
                    currentImgModel?.isFavor = true
                    dataArr[scrollIndex].isFavor = true
                    favorBarBtnItem.image = UIImage(systemName: "suit.heart.fill")
                } else {
                    view.hud.showSuccess("???????????????!")
                    currentImgModel?.isFavor = false
                    dataArr[scrollIndex].isFavor = false
                    favorBarBtnItem.image = UIImage(systemName: "suit.heart")
                }
            } else {
                view.hud.showError("????????????!")
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

