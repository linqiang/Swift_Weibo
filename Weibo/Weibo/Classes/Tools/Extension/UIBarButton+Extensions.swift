//
//  UIBarButton+Extensions.swift
//  Weibo
//
//  Created by claude on 2018/7/3.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

//创建UIBarButtonItem

extension UIBarButtonItem{
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject, action: Selector, isBack: Bool = false){
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
            btn.sizeToFit()
        }
        // 实例化 UIBarButton
        self.init(customView:btn)
    }
}
