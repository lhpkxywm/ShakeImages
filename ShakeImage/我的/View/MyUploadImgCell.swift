//
//  MyUploadImgCell.swift
//  ShakeImage
//
//  Created by MacMini on 2021/5/12.
//

import UIKit

class MyUploadImgCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    var imgUrl = "" {
        didSet {
            guard imgUrl != "" else {
                return
            }
            imageView.kf.setImage(with: URL(string: imgUrl))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSubview() {
        let rootLayout = TGRelativeLayout()
        rootLayout.tg_margin(0)
        contentView.addSubview(rootLayout)
        
        imageView.tg_margin(0)
        rootLayout.addSubview(imageView)
    }
    
}
