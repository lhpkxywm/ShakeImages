//
//  BannerView.swift
//  FundApp
//
//  Created by MacMini on 2021/4/7.
//  Copyright © 2021 LL. All rights reserved.
//

import UIKit

class BannerView: UIView {

    var tapClosure: ((Int) -> Void)?
    let scrollView = UIScrollView()
    let leftImgView = UIImageView()
    let middleImgView = UIImageView()
    let rightImgView = UIImageView()
    var imgIndex = 0
    var imgArr: [UIImage] = []
    var timer: Timer!
    var interval: TimeInterval = 0
    var startCntOffset = CGPoint()
    var endCntOffset = CGPoint()
    
    convenience init(interval: TimeInterval) {
        self.init()
        self.interval = interval
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        scrollView.delegate = self
        addSubview(scrollView)
        
        // 创建三个图片视图
        leftImgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.addSubview(leftImgView)
        middleImgView.frame = CGRect(x: width, y: 0, width: width, height: height)
        scrollView.addSubview(middleImgView)
        rightImgView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        scrollView.addSubview(rightImgView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        addGestureRecognizer(tap)
    }
    
    func configBanner(imgArr: [UIImage]) {
        configView()
        self.imgArr.removeAll()
        self.imgArr.append(contentsOf: imgArr)
        imgIndex = 0
        if imgArr.count == 0 {
            scrollView.isScrollEnabled = false
            return
        }
        if imgArr.count == 1 {
            scrollView.isScrollEnabled = false
            middleImgView.image = imgArr.first
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            return
        }
        leftImgView.image = self.imgArr.last
        middleImgView.image = self.imgArr.first
        rightImgView.image = self.imgArr[1]
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        configTimer()
    }
    
    func configView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        leftImgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        middleImgView.frame = CGRect(x: width, y: 0, width: width, height: height)
        rightImgView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
    }
    
    func configTimer() {
        guard interval > 0.001 else {
            return
        }
        timer = Timer(timeInterval: self.interval, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func tapHandler() {
        tapClosure?(imgIndex)
    }
    
    @objc func timerHandler() {
        UIView.animate(withDuration: 0.5) { [self] in
            scrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: false)
        } completion: { [self] (_ ) in
            leftImgView.image = fetchImgByIndex(index: imgIndex)
            middleImgView.image = fetchImgByIndex(index: imgIndex + 1)
            rightImgView.image = fetchImgByIndex(index: imgIndex + 2)
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            imgIndex = imgIndex == imgArr.count - 1 ? 0 : imgIndex + 1
        }
    }
    
    func fetchImgByIndex(index: Int) -> UIImage {
        var tempIdx = index
        if index < 0 {
            tempIdx = imgArr.count + index
        }
        return imgArr[tempIdx % imgArr.count]
    }
    
    func removeTimer() {
        guard let tempTimer = timer else { return }
        tempTimer.invalidate()
        timer = nil
    }
}

extension BannerView: UIScrollViewDelegate {
    // MARK: - scrollView开始滑动时调用此代理方法
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 获取开始滑动时手指的位置
        startCntOffset = scrollView.contentOffset
        // 移除定时器
        removeTimer()
    }
    // MARK: - scrollView结束滑动时调用此代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 获取结束滑动时手指的位置
        endCntOffset = scrollView.contentOffset
        // 根据手指所在的位置判断滑动方向
        if startCntOffset.x > endCntOffset.x {
            // 从左向右滑动
            leftImgView.image = fetchImgByIndex(index: imgIndex - 2)
            middleImgView.image = fetchImgByIndex(index: imgIndex - 1)
            rightImgView.image = fetchImgByIndex(index: imgIndex)
            imgIndex = (imgIndex == 0) ? imgArr.count - 1 : imgIndex - 1
        } else if startCntOffset.x < endCntOffset.x {
            // 从右向左滑动
            leftImgView.image = fetchImgByIndex(index: imgIndex)
            middleImgView.image = fetchImgByIndex(index: imgIndex + 1)
            rightImgView.image = fetchImgByIndex(index: imgIndex + 2)
            imgIndex = (imgIndex == imgArr.count - 1) ? 0 : imgIndex + 1
        }
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        if timer == nil {
            configTimer()
        } 
    }
}
