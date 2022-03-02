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
        imageBtn.tg_top.equal(20)
        imageBtn.tg_horzMargin(20)
        imageBtn.tg_height.equal(imageBtn.tg_width)
        imageBtn.setBackgroundImage(UIImage(named: "imgAdd"), for: .normal)
        imageBtn.layer.cornerRadius = 5
        imageBtn.layer.masksToBounds = true
        imageBtn.addTarget(self, action: #selector(imgBtnClick), for: .touchUpInside)
        frameLayout.addSubview(imageBtn)
        
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

        // Do any additional setup after loading the view.
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
            let imgFile = BmobFile(fileName: "img_" + timeStamp + "." + imgType, withFileData: imgData)!
            saveImgFile(imgFile: imgFile)
        }
    }
    
    func saveImgFile(imgFile: BmobFile) {
        view.hud.showLoading("正在保存，请稍候")
        let imgObj = BmobObject(className: "t_image")
        let bUser = BmobUser.current()
        if bUser != nil {
            imgObj?.setObject(bUser, forKey: "author")
            imgObj?.setObject(bUser?.objectId, forKey: "authorId")
        }
        imgFile.saveInBackground { result, error in
            if result {
                imgObj?.setObject(imgFile.url, forKey: "imageUrl")
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
            } else {
                self.view.hud.showError("图片文件上传失败!")
            }
        }
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
