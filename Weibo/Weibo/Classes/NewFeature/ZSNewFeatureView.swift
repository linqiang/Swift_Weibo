//
//  ZSNewFeatureView.swift
//  Weibo
//
//  Created by zhi on 2020/2/16.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

class ZSNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//        backgroundColor = UIColor.orange
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    class func newFeatureView() -> ZSNewFeatureView{
        let nib = UINib(nibName: "ZSNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ZSNewFeatureView
        v.frame = UIScreen.main.bounds
        return v
    }
    
    override  func awakeFromNib() {
        
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count{
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage.init(named: imageName))
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        //指定scrollView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        //隐藏按钮
        enterButton.isHidden = true
    }
    
}
extension ZSNewFeatureView: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 1. 滚动到最后一屏删除视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 判断是否为最后一页
        if page == scrollView.subviews.count{
            removeFromSuperview()
        }
        //如果是倒数第二页则显示按钮
         enterButton.isHidden = (page != scrollView.subviews.count - 1 )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //一旦滚动则隐藏按钮
        enterButton.isHidden = true
        
        // 计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        //分页空间隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
