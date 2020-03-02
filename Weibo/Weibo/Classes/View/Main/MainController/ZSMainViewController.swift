//
//  ZSMainViewController.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import SVProgressHUD
class ZSMainViewController: UITabBarController {

    // 定义定时器
    private var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildControllers()
        self.setupComposeButton()
        //设置新特性视图
        self.setupNewFeature()
//        setupTimer()
        
        // 设置代理
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK : - 监听方法
    @objc private func userLogin(n: Notification){
        
        print("用户登录通知 \(n)")
        var when = DispatchTime.now()
        //判断 n.object是否有值，如果有值，提示用户重新登录
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            when = DispatchTime.now() + 2
        }
        
        //展示用户登录控制器 --
        //这里需要看看是否需要调整
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            //当你填写完成Appkey和AppSecret后打开这里的注释------------------
//            SVProgressHUD.setDefaultMaskType(.clear)
//            let vc = UINavigationController(rootViewController: ZSOAuthViewController())
//            self.present(vc, animated: true, completion: nil)
            /// ---------------------
            
            SVProgressHUD.showInfo(withStatus: "请输入你的Appkey")
        }
        
    }
    
    @objc func composeStatus(){
        print("撰写微博")
        // FIXME: 0> 判断是否登录
               
               // 1> 实例化视图
               let v = WBComposeTypeView.composeTypeView()
               
               // 2> 显示视图 - 注意闭包的循环引用！
               v.show { [weak v] (clsName) in
                   print(clsName)
                   
                   // 展现撰写微博控制器
                   guard let clsName = clsName,
                    let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
                       else {
                           v?.removeFromSuperview()
                       return
                   }
                   
                   let vc = cls.init()
                   let nav = UINavigationController(rootViewController: vc)
                   
                   // 让导航控制器强行更新约束 - 会直接更新所有子视图的约束！
                   // 提示：开发中如果发现不希望的布局约束和动画混在一起，应该向前寻找，强制更新约束！
                   nav.view.layoutIfNeeded()
                   
                   self.present(nav, animated: true) {
                       v?.removeFromSuperview()
                   }
               }
    }
    
    // MARK : 私有组件
    // 撰写按钮
    private lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}


// MARK: -- 撰写按钮
extension ZSMainViewController{
    
    private func setupComposeButton(){
        tabBar.addSubview(composeButton)
        
        // 计算按钮的宽度
        let count = CGFloat (children.count)
        // 将向内缩进的宽度减少，能够让按钮的宽度变大，盖住容错点，
//        let w = tabBar.bounds.width / count - 1
        // 将向内缩进的宽度
         let w = tabBar.bounds.width / count
        // CGRectInset 正数向内缩进， 负数向外扩展,
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    //设置所有子控制器
    private func setupChildControllers() {
        
        // 从沙盒中获取json路径
        let dicDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (dicDir as NSString).appendingPathComponent("main.json")
        var  data = NSData(contentsOfFile: jsonPath)
        
        //判断data是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            //从bundle中加载data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        //data一定有内容，反序列化
        guard let array = ((try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String : AnyObject]]) as [[String : AnyObject]]??)
            else {
            return
        }

        //遍历数组，循环创建控制器数组
        var arrayM = [UIViewController]()
        for dict in array!{
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    //通过字典创建一个控制器
    private func controller(dict:[String : Any]) -> UIViewController{
        guard  let clsName = dict["clsName"]as? String
        ,let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? ZSBaseViewController.Type,
       let visitorDict = dict["visitorInfo"] as? [String: String]
            else{
            return UIViewController()
        }
        
        //2.创建视图控制器
        // 1.> 将clsName转成cls
        let vc = cls.init()
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict
        vc.title = title
        // 设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)
        // 设置 tabbar标题
        let nav = ZSNavigationController(rootViewController: vc)
        
        return nav
    }
}

//MARK:-- 设置新特性视图
extension ZSMainViewController{
    private func setupNewFeature(){
        
        //判断是否登录
        if !ZSNetworkManager.shared.userLogon{
            return
        }
        // 检查版本是否更新
        //如果更新，则显示新特性，否则显示欢迎
        let v = isNewVersion ? ZSNewFeatureView.newFeatureView() : ZSWelcomeView.welcomeView()
        //添加视图
        v.frame = view.bounds
        view.addSubview(v)
    }
    
    //extension中可以有计算型属性，不会占有存储空间
    ///构造函数g： 给属性分配空间
    private var isNewVersion:Bool{
          // 1. 取当前的版本号 1.0.2
            // print(Bundle.main().infoDictionary)
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            print("当前版本" + currentVersion)
            
            // 2. 取保存在 `Document(iTunes备份)[最理想保存在用户偏好]` 目录中的之前的版本号 "1.0.2"
            let path: String = ("version" as NSString).cz_appendDocumentDir()
            let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
            print("沙盒版本" + sandboxVersion)
            
            // 3. 将当前版本号保存在沙盒 1.0.2
            _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
            
            // 4. 返回两个版本号`是否一致` not new
            return currentVersion != sandboxVersion
        //用来测试新特性页面
//         return currentVersion == sandboxVersion
    }
}


//设置UITabbarViewController delegate
// 点击Tabbar 滚动到顶部，并且加载数据
extension ZSMainViewController: UITabBarControllerDelegate{
    
    // viewcontroller : 目标控制器， return： 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //1. 获取控制器在数组中的索引
        let index = (children as NSArray).index(of: viewController)
        // 2.判断当前索引是首页，同时index也是首页，表示重复点击首页
        if selectedIndex == 0 && index ==  selectedIndex{
            // 让表格到顶部
            // 获取到控制器
            let nav = children[0] as! UINavigationController
            let vc = nav.children[0] as! ZSHomeViewController
            // 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            // 刷新数据
            // FIXME: --- 这里需要修改
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                vc.loadData()
            }
            //清除tabItem的badgeItem
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        // isMember是否为某一个类，但不是子类
        return !viewController.isMember(of: UIViewController.self)
    }
}

// 时钟相关方法
extension ZSMainViewController{
    ///定义时钟
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
  @objc private func updateTimer(){
    
   if  !ZSNetworkManager.shared.userLogon {
        return
    }
    
    ZSNetworkManager.shared.unreadCount { (count) in
        self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
        }
    }
    
}


// MARK : -- 添加强制竖屏

extension AppDelegate{
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
}


