//
//  ZSOAuthViewController.swift
//  Weibo
//
//  Created by zhi on 2020/2/14.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
import SVProgressHUD

class ZSOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView(){
        self.view = webView
        self.view.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(actionFill))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppkey)&redirect_uri=\(WBRedirectURI)"
       //建立要访问的资源
        
        //建立请求
        guard let  url = URL(string: urlString) else {
            return
        }
        //加载请求
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    //MARK: --自动填充密码
    
    @objc func actionFill(){
        let js = "document.getElementById('userId').value = '这里是登录账号';"+"document.getElementById('passwd').value = '这里是登录密码';"
        webView.stringByEvaluatingJavaScript(from: js)
        
        SVProgressHUD.showInfo(withStatus: "请填写你申请的账户名和密码")
    }
    
    //监听方法
    @objc private func close(){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
 
}
//
 extension ZSOAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false{
            return true
        }
        
        if request.url?.query?.hasPrefix("code") == false{
            //取消授权
            close()
            return false
        }
        
        // MARK:--- 获取授权码
        //从query字符串中取出授权码，
      let code =  request.url?.query?.substring(from: "code=".endIndex) ?? ""
        // 使用授权码 获取AccessToken
        ZSNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
//                SVProgressHUD.showInfo(withStatus: "登录成功")
                //跳转界面 -- 通过登录成功消息
                // 1. 发送通知
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: WBUserLoginSuccessNotification)))
                
                // 2. 关闭窗口
                self.close()
            }
        }
        return false // 不需要显示回调页面
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
 }
