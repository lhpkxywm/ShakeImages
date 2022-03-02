//
//  WebViewController.swift
//  棋牌倒计时
//
//  Created by LHP on 2020/12/4.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var h5Url:String!
    var webView = WKWebView(frame: .zero)
    
    init(_ h5Url: String){
        super.init(nibName: nil, bundle: nil)
        self.h5Url = h5Url
    }
    
    override func loadView() {
        super.loadView()
        
        let frameLayout = TGFrameLayout()
        view = frameLayout
        
        webView.tg_margin(0)
        webView.uiDelegate = self;
        webView.navigationDelegate = self;
        //webView.load(URLRequest(url: URL(string: "http://dnmfiles.waityousell.com/2020/11/20/ed921cb940587591801974c2ad649da3.html")!))
        webView.load(URLRequest(url: URL(string: h5Url)!))
        frameLayout.addSubview(webView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            navigationItem.title = webView.title
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "title")
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
