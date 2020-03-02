//
//  WBStatusViewModel.swift
//  Weibo
//
//  Created by zhi on 2020/2/17.
//  Copyright © 2020 ZS. All rights reserved.
//

import Foundation
//单条微博的视图模型
//如果没有任何负累，如果希望在开发时调试，输出调试信息，需要
// 1. 遵守CustomStringConvertible
// 2. 实现 description 计算型属性
//关于表格性能优化： 1. 尽量少计算，所有素材提前计算好，2. 控件上少使用圆角半径，所有渲染属性都要注意
// 不要创建动态空间，在显示前提前创建好,根据数据来隐藏/显示
// Cell 中控件层次越少越好
class WBStatusViewModel: CustomStringConvertible{
    //微博模型
    var status: ZSWBStatus
    //会员图标 - 存储型属性（用内存换CPU）
    var memberIcon: UIImage?
    var vipIcon: UIImage?
    var reteetedStr: String? //转发文字
    var commentStr: String?
    var likeStr: String?
    
    var pictureViewSize = CGSize() // 配图视图大小
        
    //被转发微博一定没有图
    var picURLS: [ZSStatusPicture]?{
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    // 被转发微博的文字
    var retweetedAttrText: NSAttributedString?
    var statusAttrText: NSAttributedString?  //微博正文

    //行高
    var rowHeight : CGFloat = 0
    
    //构造函数
    init(model: ZSWBStatus) {
        self.status = model
        if model.user!.mbrank  > 0 && model.user!.mbrank < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
    // 认证图标
         switch model.user?.verified_type ?? -1 {
         case 0:
             vipIcon = UIImage(named: "avatar_vip")
         case 2, 3, 5:
             vipIcon = UIImage(named: "avatar_enterprise_vip")
         case 220:
             vipIcon = UIImage(named: "avatar_grassroot")
         default:
             break
         }
        
        //设置地步字符串
        reteetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        //计算配图视图大小(有原创的计算原创的，有转发的计转发的)
        pictureViewSize = calcPictureViewSize(count: picURLS?.count ?? 0)
        
        //设置微博文本
        let originFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)

        // 设置被转发微博的文字
        let retweetedName = "@" + (status.retweeted_status?.user?.screen_name ?? "")
        let retweetedText = retweetedName + ":" + (status.retweeted_status?.text ?? "")
        retweetedAttrText = CZEmoticonManager.shared.emoticonString(string: retweetedText, font: retweetedFont)

        //微博正文文本
        statusAttrText = CZEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originFont)
        updateRowHeight()
    }
    //根据当前的视图模型内容计算行高
    func updateRowHeight(){
        let margin: CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolbarHeight:CGFloat = 35
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        //计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        //正文高度
        //预期尺寸，宽度固定，高度尽量大
        // 选项，换行文本，统一使用usersLineFragmentOrigin
        //attributes:指定字体字典
        // 正文属性文本的高度
        if let text = statusAttrText {
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        // 3. 判断是否为转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            //转发文本的高度 -- 一定用 retweetedText,拼接@用户名：微博名字
            if let text = retweetedAttrText{
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        
        //配图视图
        height += pictureViewSize.height
        height += margin
        
        //底部工具栏目
        height += toolbarHeight
        //使用属性记录
        rowHeight = height
    }
    
    /// 计算指定数量的图片对应的配图视图大小
    /// - Parameter count: <#count description#>
    private func calcPictureViewSize(count: Int) -> CGSize{
        if count == 0 || count == 0{
            return CGSize()
        }

        //计算高度
        let row = (count  - 1 ) / 3 + 1
        
        //根据行数 计算高度
        var  height = ZSStatusPictureViewOutterMargin
            height += CGFloat(row) * ZSStatusPictureItemWidth
            height += CGFloat(row - 1) * ZSStatusPictureViewInnerMargin
      
        
        return CGSize(width: ZSStatusPictureViewWidth, height: height)
    }
    
    var description: String {
        return status.description
    }
    
    
    /// 使用单个图像，更新配图视图的大小
    /// - Parameter image: 网络缓存的单张图片
    func updateSingleImageSize(image: UIImage){
        
        var size = image.size
        
        size.height += ZSStatusPictureViewOutterMargin
        
        //过宽图片处理
        let maxWidth:CGFloat = 300
        let minWidth: CGFloat = 40
        if size.width > maxWidth{
            //设置最大宽度
            size.width = maxWidth
            //等比例调整宽度
            size.height = size.width * image.size.height / image.size.width
        }
        
        //过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            //等比例调整宽度
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        //注意，尺寸需要增加顶部12个点，便于计算
        size.height += ZSStatusPictureViewOutterMargin
        //重新设置配图视图大小
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    }
    
    /// 给定一个数字返回一个对应的结果
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultStr: 默认数字
    private func countString(count: Int, defaultStr: String) -> String{
        
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000{
            return count.description
        }
        
        return String(format: "%.02f万", Double(count) / 10000)
    }
}
