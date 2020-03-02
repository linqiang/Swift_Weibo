//
//  WeiBoCommon.swift
//  Weibo
//
//  Created by zhi on 2020/2/14.
//  Copyright © 2020 ZS. All rights reserved.
//

import Foundation

//应用程序信息
let WBAppkey = "" //填写你的AppKey
let WBAppSecret = "" //填写你的AppSecret
let WBRedirectURI = ""    // 填写你的回调地址
//定义全局通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"

// 定义用户登录成功通知
let WBUserLoginSuccessNotification  = "WBUserLoginSuccessNotification"


// MARK:-- 微博配图常量
let ZSStatusPictureViewOutterMargin = CGFloat (12) //微博配图外部视图的间距
let ZSStatusPictureViewInnerMargin = CGFloat(3) //微博配图内部视图的间距

//视图宽度
let ZSStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * ZSStatusPictureViewInnerMargin
//视图每个Item的高度
let ZSStatusPictureItemWidth = (ZSStatusPictureViewWidth - 2 * ZSStatusPictureViewInnerMargin) / 3
