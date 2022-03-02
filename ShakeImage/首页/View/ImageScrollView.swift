//
//  ImageScrollView.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    let rootLayout = TGRelativeLayout()

    var imgDataModel = ImageDataModel() {
        didSet {
            imageView.kf.indicatorType = .activity
            let imgURL = URL(string: imgDataModel.imgUrl)
            imageView.kf.setImage(with: imgURL, placeholder: nil, options: nil) { [self] result in
                switch result {
                case .success(let imgResult):
                    let imgWidth = imgResult.image.cgImage?.width
                    let imgHeight = imgResult.image.cgImage?.height
                    var ratio: CGFloat = 0
                    if imgWidth == nil || imgHeight == nil {
                        ratio = 0
                    } else {
                        ratio = (CGFloat)(imgHeight ?? 0) / (CGFloat)(imgWidth ?? 0)
                    }
                    if ratio > 0 {
                        imageView.tg_height.equal(imageView.tg_width).multiply(ratio)
                    }
                default:
                    break
                }
            }
        }
    }
    lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        // scaleAspectFill, .bottom, .top
        // imgView.contentMode = .top
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
        layoutSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSubview() {
        rootLayout.tg_horzMargin(0)
        rootLayout.tg_height.equal(.wrap)
        addSubview(rootLayout)
        
        imageView.tg_top.equal(0)
        imageView.tg_horzMargin(0)
        rootLayout.addSubview(imageView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
