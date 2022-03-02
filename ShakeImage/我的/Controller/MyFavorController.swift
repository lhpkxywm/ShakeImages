//
//  MyFavorController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/5/6.
//

import UIKit

class MyFavorController: BaseProjController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        emptyLabel.text = "您还没有收藏任何图片!"
        emptyLayout.addSubview(emptyLabel)
        
        emptyLayout.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我喜爱的"
        loadNetworkData()
    }
    
    // MARK: - 请求数据
    func loadNetworkData() {
        let currentUser = BmobUser.current()
        let imgQuery: BmobQuery = BmobQuery(className: "t_image")
        imgQuery.limit = 10
        imgQuery.skip = 10 * page
        imgQuery.whereKey("favorIdArr", containedIn: [currentUser?.objectId ?? ""])
        imgQuery.findObjectsInBackground { [self] resultArr, error in
            for i in 0..<resultArr!.count {
                let queryObj = resultArr![i] as! BmobObject
                let imgUrl = queryObj.object(forKey: "imageUrl") as! String
                let imgModel = ImageDataModel(imgUrl: imgUrl, isFavor: false)
                dataArr.append(imgModel)
            }
            if dataArr.count > 0 {
                collectionView.isHidden = false
                emptyLayout.isHidden = true
                collectionView.reloadData()
            } else {
                collectionView.isHidden = true
                emptyLayout.isHidden = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 一行两个
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "myUploadImgCell"
        let myUploadImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MyUploadImgCell
        myUploadImgCell?.imgUrl = dataArr[indexPath.row].imgUrl
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
