//
//  ZSVisitorView.swift
//  Weibo
//
//  Created by claude on 2018/7/18.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class ZSVisitorView: UIView {
    //注册按钮
     lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    //登录
     lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    //访客视图的信息字典[imageName / message]
    //如果是首页，imageName == ""
    var visitorInfo:[String:String]?{
        didSet{
            guard let imageName = visitorInfo?["imageName"],
            let message = visitorInfo?["message"] else {
                return
            }
            tipLabel.text = message
            // 如果是首页跳过
            if imageName == "" {
                setupAnimate()

                return
            }
            iconView.image = UIImage(named: imageName)
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    // MARK: --设置访客视图信息
    //使用字典设置访客视图的信息
    func setupInfo(dict:[String:String]){
        // 取出字典信息
        guard let imageName = dict["imageName"],
              let message = dict["message"]  else {
            return
        }
        
        // 设置消息
        
        tipLabel.text = message
        //设置图像，首页不需要设置
        if imageName == ""{
            return
        }
        
        iconView.image = UIImage(named: imageName)
    }
    // 设置消息
    
    //MARK: ---添加核心动画
    private  func setupAnimate(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        anim.isRemovedOnCompletion = false
        iconView.layer.add(anim, forKey: nil)
    }
    // MARK: - 私有控件
    // 图像视图
    private lazy var iconView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_smallicon"))
    private lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // 遮照视图
    private lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    // 提示标签
    private lazy var tipLabel: UILabel = UILabel.cz_label(withText: "关注一些人，看看，没事看看能咋，看看，就看看", fontSize: 14, color: UIColor.darkGray)
    
    
}

extension ZSVisitorView{
    func setupUI(){
        self.backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        tipLabel.textAlignment = .center
        // 取消autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 设置自动布局
        let margin: CGFloat = 20
        // 1. 图像视图
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
         addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        // 房子
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        //提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: 236))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: 100))
        
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: 100))
    
        // 遮罩页面
        let viewDict = ["maskIconView":maskIconView,
                        "regisiterButton": registerButton]
        let metrics = ["spacing" : 20]

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[regisiterButton]", options: [], metrics: metrics, views: viewDict))
    
    }
}
