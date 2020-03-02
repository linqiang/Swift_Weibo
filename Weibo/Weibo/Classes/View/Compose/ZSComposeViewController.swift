//
//  ZSComposeViewController.swift
//  Weibo
//
//  Created by zhi on 2020/2/25.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
import SVProgressHUD
class ZSComposeViewController: UIViewController {

    
    @IBOutlet weak var textView: ZSComposeTextView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    //表情输入视图
    lazy var emoticonView: ZSEmoticonInputView = ZSEmoticonInputView.inputView { [weak self] (emoticon) in

        self?.textView.insertEmoticon(em: emoticon)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //监听键盘通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardChanged),name:UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: --键盘通知
    @objc private func keyboardChanged(n:Notification){
        
        guard let rect = (n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = (n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
            return
        }
        
       
        
        //设置地步约束的高度
        let offset = view.bounds.height - rect.origin.y
        //更新约束
        toolBarBottomCons.constant = -offset - 44
        
        print("offset----- \(offset)")
        //动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    //切换表情键盘
    @objc func emoticonKeyboard(){
        // textView.inputView 就是文本框的输入视图
        //如果使用系统默认键盘，输入视图为nil
        
        //键盘视图 -  视图的宽度可以随便，就是屏幕宽度
//        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
//        keyboardView.backgroundColor = UIColor.blue
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
              
              // 3> !!!刷新键盘视图
        textView.reloadInputViews()
    }
    //MARK:-- 发布微博按钮
    @IBAction func postStatus() {
        
        print("发布按钮")
        //获取文字
        guard let text = textView.text else {
            return
        }
        
        let image = UIImage(named: "icon_small_kangaroo_loading_1")
        ZSNetworkManager.shared.postStatus(statusText: text,image: image) { (result, isSuccess) in
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            
            if isSuccess{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                    
                }
            }
        }
    }
}

// MARK: -- textView
 extension ZSComposeViewController:UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}

//MARK: -- 添加toolbar

private extension ZSComposeViewController {
    func setupUI(){
           self.view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupToolbar()
    }
    
    
    func setupToolbar(){
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                                   ["imageName": "compose_mentionbutton_background"],
                                   ["imageName": "compose_trendbutton_background"],
                                   ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                                   ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            guard let imageName = s["imageName"] else{
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            //判断actionName
           if let actionName = s["actionName"]{
            btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            //追加按钮
            items.append(UIBarButtonItem(customView: btn))
            
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        }
        // 删除末尾弹簧
        items.removeLast()
        toolbar.items = items
    }
    
    func setupNavigationBar(){
          navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
    }
}
