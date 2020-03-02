//
//  ZSStatusToolBar.swift
//  Weibo
//
//  Created by zhi on 2020/2/18.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSStatusToolBar: UIView {
    
    var ViewModel:WBStatusViewModel? {
        didSet{
            reweetedButton.setTitle(ViewModel?.reteetedStr, for: [])
            commentButton.setTitle(ViewModel?.commentStr, for: [])
            likeButton.setTitle(ViewModel?.likeStr, for: [])
        }
    }
    
@IBOutlet weak var reweetedButton: UIButton!// 转发
    
@IBOutlet weak var commentButton: UIButton! // 评论
    
@IBOutlet weak var likeButton: UIButton!  //赞
    
}
