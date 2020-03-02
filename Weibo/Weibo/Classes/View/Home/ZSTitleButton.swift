//
//  ZSTitleButton.swift
//  Weibo
//
//  Created by zhi on 2020/2/16.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSTitleButton: UIButton {
    // 如果有titile则显示title和图像，为nil则只显示文字
    init(title: String?){
        
        super.init(frame:CGRect())
        
        if title == nil{
            setTitle("首页", for: [])
        }else{
            setTitle(title! + " ", for: [])
            setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        //设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        //设置大小
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel,let imageView = imageView else{
            return
        }
        
        // 移动button 中的imagView和title 的位置
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        
        // 将 label 的 x 向左移动 imageView 的宽度
        // OC 中不允许直接修改`结构体内部的值`
        // Swift 中可以直接修改
        titleLabel.frame.origin.x = 0
        
        // 将 imageView 的 x 向右移动 label 的宽度
        imageView.frame.origin.x = titleLabel.bounds.width
    }
}
