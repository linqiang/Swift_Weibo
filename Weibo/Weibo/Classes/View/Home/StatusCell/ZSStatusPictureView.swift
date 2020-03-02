//
//  ZSStatusPictureView.swift
//  Weibo
//
//  Created by zhi on 2020/2/18.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSStatusPictureView: UIView {
//配图视图模型
    
    
    var viewModel:WBStatusViewModel?{
        didSet{
            calcViewSize()
        }
    }
    
    
    /// 根据视图模型的配图视图大小，调整内容
    private func calcViewSize(){
        //处理宽度
        /// 单图修改配图视图的大小，修改subViews[0]的宽高
        if viewModel?.picURLS?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: ZSStatusPictureViewOutterMargin,
                             width: viewSize.width,
                             height: viewSize.height - ZSStatusPictureViewOutterMargin)
        }else{
            // 无图或者多图的情况，恢复高度
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y:ZSStatusPictureViewOutterMargin ,
                             width: ZSStatusPictureItemWidth,
                             height: ZSStatusPictureItemWidth)
        }
        
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    
    var urls : [ZSStatusPicture]?{
        didSet{
            // 隐藏所有的imageView
            for v in subviews{
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                let iv  = subviews[index] as! UIImageView
                //处理四张图片
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                //设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                //显示图像
                iv.isHidden = false
                index += 1
            }
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
}

// MARK: --设置界面
extension ZSStatusPictureView{
    
    //1. Cell中的所有控件都是提前准备好，根据数据来显示
//    var clipsToBounds = true
    private func setupUI(){
        
        //设置背景颜色
        backgroundColor = superview?.backgroundColor
        //循环创建9个 imageView
        clipsToBounds = true
        let count = 3
        let rect = CGRect(x: 0,
                          y: ZSStatusPictureViewOutterMargin,
                          width: ZSStatusPictureItemWidth,
                          height: ZSStatusPictureItemWidth)
        for i in 0..<count * count {
            let iv = UIImageView()
//            iv.backgroundColor = UIColor.red
            // 设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            // 行 -> Y
            let row = CGFloat(i / count)
            // 列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (ZSStatusPictureItemWidth + ZSStatusPictureViewInnerMargin)
            let yOffset = row * (ZSStatusPictureItemWidth + ZSStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
    }
}
