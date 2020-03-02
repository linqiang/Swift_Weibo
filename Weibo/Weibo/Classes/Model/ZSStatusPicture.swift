//
//  ZSStatusPicture.swift
//  Weibo
//
//  Created by zhi on 2020/2/18.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
//微博配图模型

class ZSStatusPicture: NSObject {

    //缩略图地址
    @objc var  thumbnail_pic: String!

    override var description: String{
        return yy_modelDescription()
    }
}
