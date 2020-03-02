//
//  ZSWebViewController.swift
//  Weibo
//
//  Created by zhi on 2020/2/24.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSWebViewController: ZSBaseViewController {
    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String?{
        didSet{
               guard let urlString = urlString, let url = URL(string: urlString) else {
                   return
               }
               webView.loadRequest(URLRequest(url: url))
           }
    }
}

extension ZSWebViewController{
    override func setupTableView() {
        navItem.title = "网页"
        //设置webView
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        //设置contentInset
        
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}
