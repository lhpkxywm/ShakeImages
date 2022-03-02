//
//  HUD.swift
//  HUD
//
//  Created by zhangweiwei on 2016/10/17.
//  Copyright © 2016年 erica. All rights reserved.
//

import UIKit

public enum HUDStyle : Int {
    
    case light
    case dark
    case custom
    
}

public enum HUDMaskType : Int {
    
    case none
    case black
    case clear
    case custom
    
}

public enum HUDLayoutDirection : Int {
    
    case vertical
    
    case horizontal
    
}

extension UIView {
    
    public var hud: HUD{
        
        
        var hud: HUD!
        for subview in subviews {
            
            if let subview = subview as? HUD {
                hud = subview
                
                break
            }
        }
        
        if hud == nil {
            hud = HUD()
            addSubview(hud)
        }
        
        hud.frame = bounds
        hud.setupData()
        
        return hud
        
    }
    
}

fileprivate enum HUDLoadingAnimation : Int {
    
    case rotation
    case gif
    case none
    
}



public extension HUD {
    
    func showNotification(_ image: UIImage?, msg: String?, detailMsg: String?) {
        
        removeTimer()
        
        contentView.show(type: .notification, msg: msg, detailMsg: detailMsg, image: image)
        
        addTimer()
    }
    
     func showSuccess(_ msg: String?) {
        
        removeTimer()
        contentView.show(type: .success, msg: msg)
        addTimer()
        
    }
    
     func showError(_ msg: String?){
        
        removeTimer()
        contentView.show(type: .error, msg: msg)

        addTimer()
        
        
        
    }
    
     func showLoading(_ msg: String? = nil){
        
        removeTimer()
        contentView.show(type: .loading, msg: msg)

        
        
    }
    
     func showInfo(_ msg: String?) {
        
        
        removeTimer()
        contentView.show(type: .info, msg: msg)

        addTimer()
        
        
    }
    
     func showProgress(_ progress: Double, msg: String? = nil) {
        
        removeTimer()
        contentView.show(type: .progress, msg: msg, progress: progress)

        
        
    }
    
    
    @objc func dismiss(){
        
        timer?.invalidate()
        timer = nil
        
        UIView.animate(withDuration: 0.25, animations: { 
            
            self.alpha = 0
        }) { (_) in
            
            self.removeFromSuperview()
        }
        
    }
    
    
}



public class HUD: UIView {
    /************
     
     配置全局属性
     
     *************/
    
    public static var defaultDelay: TimeInterval = 2
    public static var defaultStyle: HUDStyle = .dark
    public static var defaultMaskType: HUDMaskType = .none
    public static var defaultSuccessImage: UIImage? = UIImage(named: "hud_success")
    public static var defaultErrorImage: UIImage? = UIImage(named: "hud_error")
    public static var defaultInfoImage: UIImage? = UIImage(named: "hud_info")
    public static var defaultLoadingImage: UIImage? = UIImage(named: "hud_loading")
    public static var defaultLayoutDirection: HUDLayoutDirection = .vertical
    public static var defaultLoadingImages: [UIImage]?
    public static var defaultAnimationDuration: TimeInterval = 2
    
    public static var defaultContentInset: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    public static var defaultHorizontalMargin: CGFloat = 10
    public static var defaultVerticalMargin: CGFloat = 10
    public static var defaultProgressSize: CGSize = CGSize(width: 35, height: 35)
    
    public static var isDefaultShowProgressLabel = true
    
    public static var defaultStyleColor: UIColor?
    public static var defaultTextColor: UIColor?
    public static var defaultStyleAlpha: CGFloat = 0.75
    
/************ 
     
可针对某实例配置对应属性,默认是使用全局属性
     
*************/
    
    /*自动消失时间*/
    public var delay = defaultDelay
    /*背景遮罩样式*/
    public var maskType: HUDMaskType = defaultMaskType{
        didSet{
            
            switch maskType {
            case .none:
                backgroundColor = UIColor.clear
                isUserInteractionEnabled = false
                
            case .clear:
                backgroundColor = UIColor.clear
                isUserInteractionEnabled = true
                
            case .black:
                backgroundColor = UIColor(white: 0, alpha: 0.25)
                isUserInteractionEnabled = true
                
                
            case .custom:
                break
                
            }

        }
    }
    /*内容样式*/
    public var style: HUDStyle = defaultStyle{
        didSet{
            contentView.style = style

        }
    }
    
    
    fileprivate lazy var contentView: HUDContentView = {
       
        let contentView = HUDContentView()
        contentView.layer.cornerRadius = 10
        
        return contentView
        
    }()
    
    
    /*life cycle*/
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    fileprivate var timer: Timer?
    
    fileprivate func removeTimer(){
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    fileprivate func addTimer(){
        
        self.timer = Timer(timeInterval: delay, target: self, selector: #selector(HUD.dismiss), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
}

// MARK: - Private Method
extension HUD{
    
    fileprivate func setupUI() {
    
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
        
    }
    
    fileprivate func setupData() {
        
        delay = HUD.defaultDelay
        maskType = HUD.defaultMaskType
        style = HUD.defaultStyle
        
        contentView.errorImage = HUD.defaultErrorImage
        contentView.loadingImage = HUD.defaultLoadingImage
        contentView.loadingImages = HUD.defaultLoadingImages
        contentView.infoImage = HUD.defaultInfoImage
        contentView.successImage = HUD.defaultSuccessImage
        
        contentView.contentInset = HUD.defaultContentInset
        contentView.horizontalMargin = HUD.defaultHorizontalMargin
        contentView.verticalMargin = HUD.defaultVerticalMargin
        contentView.layoutDirection = HUD.defaultLayoutDirection
        contentView.animationDuration = HUD.defaultAnimationDuration
        contentView.isShowProgressLabel = HUD.isDefaultShowProgressLabel
        
    }
    
    
    
}

// MARK: - Tool
extension UIImage{
    
    func render(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale);
        
        let ctx = UIGraphicsGetCurrentContext();
        
        draw(in: rect)
        
        ctx?.setFillColor(color.cgColor)
        ctx?.setAlpha(1)
        ctx?.setBlendMode(.sourceAtop)
        ctx?.fill(rect)
        
        let image = UIImage(cgImage: ctx!.makeImage()!, scale: scale, orientation: imageOrientation)
        
        UIGraphicsEndImageContext();
        
        return image;
        
    }
    
}







