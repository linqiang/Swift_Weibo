//
//  ZSUSerModel.swift
//  Weibo
//
//  Created by zhi on 2020/2/17.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
//用户模型数据

//基本数据类型 & private 不能使用KVC设置，即不能使用可选类型

class ZSUSerModel: NSObject {
    //基本数据类型
   @objc var id: Int64 = 0
   @objc var screen_name: String? // 用户昵称
   @objc var profile_image_url: String? // 用户头像地址
   @objc var verified_type: Int = 0   // 认证类型  220:达人，0:认证用户 -1: 没有认证， 2，3，5:企业认证
   @objc var mbrank: Int = 0 //会员等级
    
    override var description: String {
        yy_modelDescription()
    }
}
