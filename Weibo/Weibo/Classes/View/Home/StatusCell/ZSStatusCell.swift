//
//  ZSStatusCell.swift
//  Weibo
//
//  Created by zhi on 2020/2/17.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

//微博Cell 的协议
@objc protocol WBStatusCellDelegate:NSObjectProtocol {
    @objc optional func statusCellDidSelectedURLString(cell: ZSStatusCell, urlString: String)
}

class ZSStatusCell: UITableViewCell {
    
    ///代理属性
    weak var delegate : WBStatusCellDelegate?
    
    @IBOutlet weak var iconVIew: UIImageView! // 头像
    @IBOutlet weak var nameLabel: UILabel! //姓名
    @IBOutlet weak var memberIconView: UIImageView! //会员图标
    
    @IBOutlet weak var sourceLabel: UILabel!//来源
    @IBOutlet weak var timeLabel: UILabel! //时间
    @IBOutlet weak var statusLabel: FFLabel! //微博正文
    
    @IBOutlet weak var vipIconView: UIImageView!  // 认证图标
    @IBOutlet weak var toolBar: ZSStatusToolBar!
    
    @IBOutlet weak var pictureView: ZSStatusPictureView!  //配图视图
    
    @IBOutlet weak var pictureTopCons: NSLayoutConstraint!
    
    // 被转发微博，原创微博没有这个属性所以需要用 "?"
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    // 微博视图模型
   var viewModel:WBStatusViewModel?{
       didSet{
           nameLabel.text = viewModel?.status.user?.screen_name
           memberIconView.image = viewModel?.memberIcon
           vipIconView.image = viewModel?.vipIcon
           //用户头像
           iconVIew.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
           //底部工具栏
           toolBar.ViewModel = viewModel
           
           //测试高度
           pictureView.viewModel = viewModel
           // 设置配图视图的URL 数据
           pictureView.urls = viewModel?.picURLS
           retweetedLabel?.attributedText = viewModel?.retweetedAttrText //微博转发文本
           
           statusLabel.attributedText = viewModel?.statusAttrText// 微博正文
           //微博来源
           sourceLabel.text = viewModel?.status.source
       }
   }
    override func awakeFromNib() {
        super.awakeFromNib()
        //离屏渲染 -异步绘制
        self.layer.drawsAsynchronously = true
        //栅格化
        self.layer.shouldRasterize = true
        //使用栅格化,必须制定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ZSStatusCell:FFLabelDelegate{
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        //判断是否是URL
        if !text.hasPrefix("http://"){
            return
        }
        // 插入 ? 表示如果代理没有实现协议方法，就什么都不做
        // 如果使用 !，代理没有实现协议方法，仍然强行执行，会崩溃！
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
    }
}
