//
//  ImageDetailController.swift
//  ShakeImage
//
//  Created by LHP on 2021/5/9.
//

import UIKit

class ImageDetailController: BaseProjController, UIScrollViewDelegate {
    
    var imgScrollView = ImageScrollView()
    var imgDataModel: ImageDataModel?
    
    init(imgDataModel: ImageDataModel) {
        super.init(nibName: nil, bundle: nil)
        self.imgDataModel = imgDataModel
        imgScrollView.imgDataModel = imgDataModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        imgScrollView.tg_margin(0)
        frameLayout.addSubview(imgScrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "图片详情"
        
        let saveBarBtnItem = UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down"), style: .plain, target: self, action: #selector(saveBarItemClick))
        navigationItem.rightBarButtonItem = saveBarBtnItem
    }
    
    // MARK: - 存储图片到本地
    @objc func saveBarItemClick() {
        UIImageWriteToSavedPhotosAlbum(imgScrollView.imageView.image!, self, #selector(imageSavedToPhotosAlbum(image:didFinishSabingWithError:contentInfo:)), nil)
    }
    
    @objc func imageSavedToPhotosAlbum(image: UIImage, didFinishSabingWithError: Error?, contentInfo: AnyObject) {
        view.hud.delay = 2
        if didFinishSabingWithError == nil {
            view.hud.showSuccess("保存成功!")
        } else {
            view.hud.showError("保存失败!")
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
