//
//  ZSWelcomeView.swift
//  Weibo
//
//  Created by zhi on 2020/2/16.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
import SDWebImage
class ZSWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    //    override init(frame: CGRect) {
//        super.init(frame:frame)
//        backgroundColor = UIColor.white
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    class func welcomeView() -> ZSWelcomeView{
        let nib = UINib(nibName: "ZSWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ZSWelcomeView
        v.frame = UIScreen.main.bounds
        return v
    }
    
    
    
    override func awakeFromNib() {
        guard let urlString = ZSNetworkManager.shared.userAccount.avatar_large, let url = URL(string: urlString) else{
            return
        }
        //设置头像，如果网络图像没有下载完成，先显示占位图像
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"), options: [], completed: nil)
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.layer.masksToBounds = true
    }
    
    // 自动布局完成更新完成约束之后，会自动调用此方法
    // 通常是对子视图布局进行修改
//    override func layoutSubviews() {
//        return
//    }
    
    //视图被添加到window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // -layoutSubViews 会按照当前的约束直接更新空间位置，
        // 执行之后，控件所在位置，就是XIB中的布局未必
        self.layoutIfNeeded()
        bottomCons.constant = bounds.size.height - 200
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [], animations: {
                        // 更新约束
                        self.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
}
