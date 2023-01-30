//
//  MyUploadImageController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class MyUploadImageController: BaseProjController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var page = 0
    var dataArr: [ImageDataModel] = []
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: screenWidth/2 - 2.5, height: screenWidth)
        // 每个相邻的layout的上下间隔
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        flowLayout.footerReferenceSize = CGSize(width: 0, height: 15)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    let emptyLayout = TGLinearLayout(.vert)
    
    override func loadView() {
        super.loadView()
        
        collectionView.tg_margin(0)
        collectionView.register(MyUploadImgCell.self, forCellWithReuseIdentifier: "myUploadImgCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        frameLayout.addSubview(collectionView)
        
        emptyLayout.tg_top.equal(screenWidth/3)
        emptyLayout.tg_horzMargin(100)
        emptyLayout.tg_height.equal(screenWidth)
        emptyLayout.tg_gravity = TGGravity.horz.center
        frameLayout.addSubview(emptyLayout)
        
        let emptyImgView = UIImageView(image: UIImage(named: "emptyData"))
        emptyImgView.tg_width.equal(196)
        emptyImgView.tg_height.equal(128)
        emptyLayout.addSubview(emptyImgView)
        
        let emptyLabel = UILabel()
        emptyLabel.tg_top.equal(10)
        emptyLabel.tg_horzMargin(0)
        emptyLabel.tg_height.equal(40)
        emptyLabel.textColor = .label
        emptyLabel.font = .systemFont(ofSize: 15)
        emptyLabel.textAlignment = .center
        emptyLabel.text = "您还没有上传任何图片!"
        emptyLayout.addSubview(emptyLabel)
        
        let uploadBtn = UIButton()
        uploadBtn.tg_top.equal(10)
        uploadBtn.tg_width.equal(196)
        uploadBtn.tg_height.equal(44)
        uploadBtn.setTitleColor(.systemBlue, for: .normal)
        uploadBtn.titleLabel?.font = .systemFont(ofSize: 15)
        uploadBtn.setTitle("点我去上传图片", for: .normal)
        uploadBtn.layer.borderWidth = 1
        uploadBtn.layer.borderColor = UIColor.systemBlue.cgColor
        uploadBtn.layer.cornerRadius = 4
        uploadBtn.layer.masksToBounds = true
        uploadBtn.addTarget(self, action: #selector(uploadBtnClick), for: .touchUpInside)
        emptyLayout.addSubview(uploadBtn)
        emptyLayout.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "我上传的"
        loadNetworkData()
        
    }
    
    // MARK: - 请求数据
    func loadNetworkData() {
        let currentUserId = UserInfoModel.shared.account
        var params = [String: Any]()
        params["key"] = hostPublicAesKey
        let jsonDict = [
            "table": "t_image",
            "column": "*",
            "where": "userId='\(currentUserId)'",
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
                        }
                    }
                    if dataArr.count > 0 {
                        collectionView.isHidden = false
                        emptyLayout.isHidden = true
                        collectionView.reloadData()
                    } else {
                        collectionView.isHidden = true
                        emptyLayout.isHidden = false
                    }
                } else {
                    let msg = resultDict["msg"] as? String
                    view.hud.showError(msg)
                }
            }
        }
    }
    // MARK: - 去上传图片
    @objc func uploadBtnClick() {
        tabBarController?.selectedIndex = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 一行两个
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "myUploadImgCell"
        let myUploadImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MyUploadImgCell
        myUploadImgCell?.imgUrl = dataArr[indexPath.row].imageUrl
        return myUploadImgCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickModel = dataArr[indexPath.row]
        let imageDetailVC = ImageDetailController(imgDataModel: clickModel)
        navigationController?.pushViewController(imageDetailVC, animated: true)
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
