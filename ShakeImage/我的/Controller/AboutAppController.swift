//
//  AboutAppController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/4/30.
//

import UIKit

class AboutAppController: BaseProjController {
    
    let contentLayout = TGLinearLayout(.vert)
    var appIconView = UIImageView()
    
    override func loadView() {
        super.loadView()
        contentLayout.tg_margin(0)
        contentLayout.tg_gravity = TGGravity.horz.center
        frameLayout.addSubview(contentLayout)
        
        appIconView = UIImageView(image: UIImage(named: "AppIcon"))
        appIconView.tg_top.equal(44)
        appIconView.tg_width.equal(150)
        appIconView.tg_height.equal(150)
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(qrLongTapClick))
        appIconView.isUserInteractionEnabled = true
        appIconView.addGestureRecognizer(longTap)
        contentLayout.addSubview(appIconView)
        
        let verStr = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let verLabel = UILabel()
        verLabel.tg_top.equal(10)
        verLabel.tg_width.equal(200)
        verLabel.tg_height.equal(40)
        verLabel.textColor = .label
        verLabel.font = .systemFont(ofSize: 15)
        verLabel.textAlignment = .center
        verLabel.text = "版本号:" + verStr
        contentLayout.addSubview(verLabel)
        
        let policyLayout = TGLinearLayout(.horz)
        policyLayout.tg_top.equal(20)
        policyLayout.tg_horzMargin(0)
        policyLayout.tg_height.equal(44)
        policyLayout.tg_padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        policyLayout.tg_gravity = TGGravity.vert.center
        policyLayout.tg_setTarget(self, action: #selector(policyLayoutClick), for: .touchUpInside)
        policyLayout.backgroundColor = UIColor(named: "BackColor")
        policyLayout.tg_bottomBorderline = TGBorderline(color: .lightGray)
        contentLayout.addSubview(policyLayout)
        
        let policyLabel = UILabel()
        policyLabel.tg_width.equal(300)
        policyLabel.tg_height.equal(40)
        policyLabel.textColor = .label
        policyLabel.font = .systemFont(ofSize: 14)
        policyLabel.text = "用户协议与隐私政策"
        policyLayout.addSubview(policyLabel)
        
        let arrowImgView = UIImageView(image: UIImage(named: "more_arrow"))
        arrowImgView.tg_left.equal(TGWeight(1))
        arrowImgView.tg_width.equal(32)
        arrowImgView.tg_height.equal(32)
        policyLayout.addSubview(arrowImgView)
        
        let contactLayout = TGLinearLayout(.horz)
        contactLayout.tg_top.equal(0)
        contactLayout.tg_horzMargin(0)
        contactLayout.tg_height.equal(44)
        contactLayout.tg_padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        contactLayout.tg_gravity = TGGravity.vert.center
        contactLayout.tg_setTarget(self, action: #selector(contactLayoutClick), for: .touchUpInside)
        contactLayout.backgroundColor = UIColor(named: "BackColor")
        contentLayout.addSubview(contactLayout)
        
        let contactLabel = UILabel()
        contactLabel.tg_width.equal(300)
        contactLabel.tg_height.equal(40)
        contactLabel.textColor = .label
        contactLabel.font = .systemFont(ofSize: 14)
        contactLabel.text = "联系作者：微信446204606"
        contactLayout.addSubview(contactLabel)
        
        let arrowIconView = UIImageView(image: UIImage(named: "more_arrow"))
        arrowIconView.tg_left.equal(TGWeight(1))
        arrowIconView.tg_width.equal(32)
        arrowIconView.tg_height.equal(32)
        contactLayout.addSubview(arrowIconView)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "关于抖图"
        
        let shareBarBtnItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareBarBtnItemClick))
        navigationItem.rightBarButtonItem = shareBarBtnItem
    }
    
    @objc func shareBarBtnItemClick() {
        let shareText = "抖图——一个无声版的抖音"
        let shareImage = appIconView.image
        let shareUrl = URL(string: "https://apps.apple.com/cn/app/id1567730647")
        let activityVC = UIActivityViewController(activityItems: [shareText, shareImage!, shareUrl!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
        present(activityVC, animated: true, completion: nil)
    }
    
    @objc func qrLongTapClick(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            let alertVC = UIAlertController(title: "保存图片", message: "", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "保存", style: .default) { [self] action in
                UIImageWriteToSavedPhotosAlbum(appIconView.image!, self, #selector(imageSavedToPhotosAlbum(image:didFinishSabingWithError:contentInfo:)), nil)
            }
            alertVC.addAction(saveAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc func imageSavedToPhotosAlbum(image: UIImage, didFinishSabingWithError: Error?, contentInfo: AnyObject) {
        view.hud.delay = 2
        if didFinishSabingWithError == nil {
            view.hud.showSuccess("保存成功!")
        } else {
            view.hud.showError("保存错误!")
        }
    }
    
    @objc func policyLayoutClick() {
        let policyController = WebViewController("http://dnmfiles.waityousell.com/2020/11/20/ed921cb940587591801974c2ad649da3.html")
        navigationController?.pushViewController(policyController, animated: true)
    }
    
    @objc func contactLayoutClick() {
        
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
