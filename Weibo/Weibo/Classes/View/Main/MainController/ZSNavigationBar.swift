//
//  ZSNavigationBar.swift
//  Weibo
//
//  Created by claude on 2018/7/12.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class ZSNavigationBar: UINavigationBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground") {
                subview.frame = self.bounds
            } else if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: 20, width:UIScreen.cz_screenWidth() , height: 44)
            }
        }
    }
}
