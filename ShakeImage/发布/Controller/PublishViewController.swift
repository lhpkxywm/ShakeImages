//
//  PublishViewController.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class PublishViewController: BaseProjController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var imageBtn: UIButton = {
        let imageBtn = UIButton()
        return imageBtn
    }()
    
    var pickImage :UIImage?
    var imgType: String = ""
    
    override func loadView() {
        super.loadView()
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_margin(0)
        frameLayout.addSubview(contentLayout)
        
        imageBtn.tg_top.equal(20)
        imageBtn.tg_horzMargin(20)
        imageBtn.tg_height.equal(imageBtn.tg_width)
        imageBtn.setBackgroundImage(UIImage(named: "imgAdd"), for: .normal)
        imageBtn.layer.cornerRadius = 5
        imageBtn.layer.masksToBounds = true
        imageBtn.addTarget(self, action: #selector(imgBtnClick), for: .touchUpInside)
        contentLayout.addSubview(imageBtn)
        
        let label = UILabel()
        label.tg_top.equal(20)
        label.tg_horzMargin(20)
        label.tg_height.equal(.wrap)
        label.textColor = .label
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = "您上传的所有图片、动图都将进行人工审核，对于违规、不雅以及令人产生不适的图片，将会被系统删除。"
        contentLayout.addSubview(label)
        
        let saveBtn = UIButton()
        saveBtn.tg_bottom.equal(20)
        saveBtn.tg_horzMargin(20)
        saveBtn.tg_height.equal(44)
        saveBtn.backgroundColor = Color_Theme
        saveBtn.layer.cornerRadius = 4
        saveBtn.layer.masksToBounds = true
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = .systemFont(ofSize: 15)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        frameLayout.addSubview(saveBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let shareBarBtnItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareBarBtnItemClick))
        shareBarBtnItem.tintColor = .red
        navigationItem.rightBarButtonItem = shareBarBtnItem
    }
    
    @objc func shareBarBtnItemClick() {
        let shareText = "抖图——一个无声版的抖音"
        let shareImage = UIImage(named: "AppIcon")
        let shareUrl = URL(string: "https://apps.apple.com/cn/app/id1567730647")
        let activityVC = UIActivityViewController(activityItems: [shareText, shareImage!, shareUrl!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
        present(activityVC, animated: true, completion: nil)
    }
    
    @objc func imgBtnClick() {
        let imgLibPicker = UIImagePickerController()
        imgLibPicker.delegate = self
        imgLibPicker.sourceType = .photoLibrary
        present(imgLibPicker, animated: true) {
            
        }
    }
    
    @objc func saveBtnClick() {
        if pickImage == nil {
            view.hud.delay = 2
            view.hud.showError("请选择图片")
        } else {
            let imgData: Data
            if self.imgType == "jpg" || self.imgType == "jpeg" {
                imgData = (pickImage?.jpegData(compressionQuality: 1))!
            } else if self.imgType == "jpg" {
                imgData = (pickImage?.pngData())!
            } else {
                imgData = (pickImage?.pngData())!
            }
            let timeStamp = String(Int(Date().timeIntervalSince1970))
            let imgName = "img_" + timeStamp
            self.qiNiuUploadFile(imgName: imgName, imgData: imgData)
        }
    }
    
    func qiNiuUploadFile(imgName: String, imgData: Data) {
        view.hud.showLoading("正在保存，请稍候")
        let qnConfig = QNConfiguration.build{ (builder) in
            builder?.useHttps = true
        }
        let upManager = QNUploadManager.sharedInstance(with: qnConfig)
        let option = QNUploadOption { Key, percent in
            self.view.hud.showLoading("上传进度=\(percent)")
        }
        let token = GenToken.make("MR8RPHriYToU4xtQUo-DkQft5yCXJMTjU7hr3OeV", secretKey: "X4IlA-y3kkIrqsOePr4M9ilhcO5Au9TTBDLAAeEC", bucket: "kokofiles") ?? ""
        upManager?.put(imgData, key: imgName, token: token, complete: { info, key, resp in
            if resp != nil {
                self.view.hud.showSuccess("图片保存成功!")
                let imgFileUrl = qiNiuFileHost + imgName
                var params = [String: Any]()
                params["key"] = hostPublicAesKey
                let jsonDict = [
                    "table": "t_image",
                    "column": "`imageUrl`,`imgType`",
                    "value": "('\(imgFileUrl)','-1')",
                    "timestamp": Int(Date().timeIntervalSince1970)
                ]
                let aesJsonStr = AesTool.encryptAes(jsonDict: jsonDict, aesKey: hostSecretAesKey)
                params["data"] = aesJsonStr
                let signature = (hostPublicAesKey + aesJsonStr + hostSecretAesKey).md5()
                params["signature"] = signature
                NetworkProvider.request(NetworkAPI.publishImage(params: params)) { [self] result in
                    if case .success(let response) = result {
                        // 解密数据
                        let resultDict = dealResponseData(respData: response.data, aesKey: hostSecretAesKey)
                        if let resultCode = resultDict["code"] as? Int, resultCode == 1 {
                            view.hud.showSuccess("成功")
                        } else {
                            let msg = resultDict["msg"] as? String
                            view.hud.showError(msg)
                        }
                    } else {
                        print("failure")
                    }
                }

                /*
                let imgObj = BmobObject(className: "t_image")
                let bUser = BmobUser.current()
                if bUser != nil {
                    imgObj?.setObject(bUser, forKey: "author")
                    imgObj?.setObject(bUser?.objectId, forKey: "authorId")
                }
                imgObj?.setObject(imgFileUrl, forKey: "imageUrl")
                imgObj?.saveInBackground(resultBlock: { [self] result, error in
                    if result {
                        view.hud.showSuccess("图片保存成功!")
                        pickImage = nil
                        imgType = ""
                        imageBtn.setBackgroundImage(UIImage(named: "imgAdd"), for: .normal)
                    } else {
                        self.view.hud.showError("图片数据保存失败!")
                    }
                })
                 */
            }
        }, option: option)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickImage = info[.originalImage] as? UIImage
        let imgTypeURL = info[.imageURL] as! URL
        imgType = imgTypeURL.pathExtension
        imageBtn.setBackgroundImage(pickImage, for: .normal)
        dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
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
