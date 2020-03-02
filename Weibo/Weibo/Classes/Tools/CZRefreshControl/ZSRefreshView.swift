//
//  ZSRefreshView.swift
//  Weibo
//
//  Created by zhi on 2020/2/21.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSRefreshView: UIView {

    var refreshState: ZSRefreshControl.CZRefreshState = .Normal{
        didSet{
            switch refreshState {
            case .Normal:
                // 恢复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()

                tipLabel?.text = "继续拉...."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel?.text = "放手刷新....."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(.pi - 0.001))

                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新中...."
                // 隐藏提示图标
               tipIcon?.isHidden = true
               
               // 显示菊花
               indicator?.startAnimating()
            }
        }
    }
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?
    /// 父视图的高度 - 为了刷新控件不需要关心当前具体的刷新视图是谁！
    var parentViewHeight: CGFloat = 0
    
    class func refreshView() -> ZSRefreshView {
         
         let nib = UINib(nibName: "CZRefreshView", bundle: nil)
         
         return nib.instantiate(withOwner: nil, options: nil)[0] as! ZSRefreshView
     }
}
