//
//  ZSNavigationController.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

class ZSNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        //MARK: -- 判断类型
        if let vc = viewController as? ZSBaseViewController{
            var title = "返回"
            if children.count == 1{
                title = children.first?.title ?? "返回"
                
                // MARK:  -- 别瞎几把乱写，放到下面去了
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBack: true)

            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
   
    
    @objc private func popToParent(){
        popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
