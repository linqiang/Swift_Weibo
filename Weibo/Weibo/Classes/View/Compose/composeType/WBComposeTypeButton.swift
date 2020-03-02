//
//  WBComposeTypeButton.swift
//  Weibo
//
//  Created by zhi on 2020/2/21.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    /// 点击按钮要展现控制器的类型
      var clsName: String?
    /// 使用图像名称/标题创建按钮
    /// - Parameters:
    ///   - imageName: <#imageName description#>
    ///   - title: <#title description#>
    class func composeTypeButton(imageName: String, title:String) -> WBComposeTypeButton {
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: self, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageVIew.image = UIImage(named: imageName)
        btn.titlelabel.text = title
        return btn
    }
    
}
