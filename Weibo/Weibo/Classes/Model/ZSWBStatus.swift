//
//  ZSWBStatus.swift
//  Weibo
//
//  Created by zhi on 2018/7/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import YYModel

class ZSWBStatus: NSObject {
    
    @objc var id: Int64 = 0
    @objc var text: String?
    
    @objc  var user: ZSUSerModel?
    
    @objc var attitudes_count: Int = 0  //点赞数量👍
    @objc var reposts_count: Int = 0  //转发数
    @objc var comments_count: Int = 0  //评论数
    
    @objc var pic_urls:[ZSStatusPicture]? //微博配图模型
    
    @objc var retweeted_status: ZSWBStatus? //被转发原创微博模型
    @objc var created_at: String? //微博创建时间
    @objc var source: String?{
        didSet{
            
            //重新计算来源并保存
            //在didSet中，给source重新设置值，不会调用didSet
            source = "来自" + (source?.cz_href()?.text ?? "")
        }
    } //微博来源
    //重写Description 的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
    
    //YY_Model 字典转模型时，如果发现一个数组属性，尝试使用类方法，如果实现YYModel就尝试使用类来实例化数组中的对象
    @objc class func modelContainerPropertyGenericClass() -> [String: AnyClass]{
        return ["pic_urls" : ZSStatusPicture.self]
    }
}
