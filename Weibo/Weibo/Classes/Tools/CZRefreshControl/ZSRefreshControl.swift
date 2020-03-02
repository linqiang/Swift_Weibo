//
//  ZSRefreshControl.swift
//  Weibo
//
//  Created by zhi on 2020/2/20.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSRefreshControl: UIControl {

   /// 刷新状态
    ///
    /// - Normal:      普通状态，什么都不做
    /// - Pulling:     超过临界点，如果放手，开始刷新
    /// - WillRefresh: 用户超过临界点，并且放手
    enum CZRefreshState {
        case Normal
        case Pulling
        case WillRefresh
    }
    private let CZRefreshOffset: CGFloat = 126  //刷新状态切换的零界点

    ///属性
    ///刷新控件的父视图， 下拉刷新控件应该适用于UITableView / UIScrollView
    private weak var scrollView: UIScrollView?
    private lazy var refreshView: ZSRefreshView = ZSRefreshView.refreshView()

       /// 刷新视图
//       private lazy var refreshView: CZRefreshView = CZRefreshView.refreshView()
    //构造函数
    init(){
        super.init(frame:CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    
    /// wllMove addSubView 方法会调用
    ///当添加父视图的时候，newSuperView是父视图
    /// - Parameter newSuperview:
    override func willMove(toSuperview newSuperview: UIView?) {
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        //记录父视图
        scrollView = sv
        
        //KVO 监听父视图的contentOffSet
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        super.removeFromSuperview()
    }
    // 所有KVO统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
 
      // contentOffset 的 y 值跟 contentInset 的 top 有关
        //print(scrollView?.contentOffset)
        
        guard let sv = scrollView else {
            return
        }
        
        // 初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        // 可以根据高度设置刷新控件的 frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        // print(height)
        
        // --- 传递父视图高度，如果正在刷新中，不传递
        // --- 把代码放在`最合适`的位置！
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
        
        // 判断临界点 - 只需要判断一次
        if sv.isDragging {
            
            if height > CZRefreshOffset && (refreshView.refreshState == .Normal) {
                print("放手刷新")
                refreshView.refreshState = .Pulling
            } else if height <= CZRefreshOffset && (refreshView.refreshState == .Pulling) {
                print("继续使劲...")
                refreshView.refreshState = .Normal
            }
        } else {
            // 放手 - 判断是否超过临界点
            if refreshView.refreshState == .Pulling {
                print("准备开始刷新")
                
                beiginRefreshing()
                
                // 发送刷新数据事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
   //开始刷新
    func beiginRefreshing(){
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .WillRefresh{
            return
        }
        //设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        //调整表格的间距
        var inset = sv.contentInset
        inset.top += CZRefreshOffset
        sv.contentInset = inset
    }
    //结束刷新
    func endRefreshing(){
        print("结束刷新")
      
      guard let sv = scrollView else {
          return
      }
      
      // 判断状态，是否正在刷新，如果不是，直接返回
      if refreshView.refreshState != .WillRefresh {
          return
      }
      
      // 恢复刷新视图的状态
      refreshView.refreshState = .Normal
      
      // 恢复表格视图的 contentInset
      var inset = sv.contentInset
      inset.top -= CZRefreshOffset
      
      sv.contentInset = inset
  }
}

extension ZSRefreshControl {
    
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        // 设置超出边界不显示
        // clipsToBounds = true
        
        // 添加刷新视图 - 从 xib 加载出来，默认是 xib 中指定的宽高
        addSubview(refreshView)
        
        // 自动布局 - 设置 xib 控件的自动布局，需要指定宽高约束
        // 提示：iOS 程序员，一定要会原生的写法，因为：如果自己开发框架，不能用任何的自动布局框架！
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}
