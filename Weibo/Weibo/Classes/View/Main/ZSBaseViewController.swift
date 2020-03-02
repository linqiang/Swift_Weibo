//
//  ZSBaseViewController.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit


class ZSBaseViewController: UIViewController {

    //用户登录标记
//    var userLogon = true
//     var userLogon = false
    //访客视图信息字典
    var visitorInfoDictionary:[String: String]?
    
    lazy var navigationBar = ZSNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    lazy var navItem = UINavigationItem()
    var tableView : UITableView?
    //刷新控件
    var refreshControl: ZSRefreshControl?
    
    //标记是否有下拉刷新
    var isPullup = false
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpBaseUI()
//        loadData()
        ZSNetworkManager.shared.userLogon ? loadData() :()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
    }
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }

   @objc func loadData() {
        refreshControl?.endRefreshing()
    }

}

// MARK: --访客视图监听方法
extension ZSBaseViewController{
    
    //用户登录成功处理
    @objc private func loginSuccess(n: Notification){
        
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        view = nil
        //注销通知 -> 重新执行 viewDidLoad 会再次注册，避免被重复注册
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    @objc private func login(){
        print("用户登录")
        // 发送通知
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: WBUserShouldLoginNotification)))
    }
    @objc private func regisiter(){
        print("用户注册")
    }
}

// MARK: -- 设置界面

extension ZSBaseViewController{
     private func setUpBaseUI(){
//        view.backgroundColor = UIColor.cz_random()
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
//        setupTableView()
//        userLogon ? setupTableView() : setupVisitorView()
        // 如果登陆成功显示内容，没有成功则显示访客视图
//        (ZSNetworkManager.shared.accessToken != nil) ? setupTableView() : setupVisitorView()
        ZSNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    // MARK: -- 设置tableView
    @objc func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //设置内容缩紧
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height-20, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        //FIXME: --- 这里需要修改
        //修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        refreshControl = ZSRefreshControl()
        // 添加到视图
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    // MARK: --设置访客视图
    private func setupVisitorView(){
        let visitorView = ZSVisitorView(frame: view.bounds)
//        visitorView.backgroundColor = UIColor.cz_random()
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        print("访客视图\(visitorView)")
        //设置访客视图信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        //添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for:.touchUpInside )
        visitorView.registerButton.addTarget(self, action: #selector(regisiter), for: .touchUpInside)
        // 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(regisiter))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    
    }
    
    // MARK: -- 抽取导航条方法
    
    private func setupNavigationBar(){
        // 添加导航栏
        view.addSubview(navigationBar)
        //将Item设置给bar
        navigationBar.items = [navItem]
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        navigationBar.titleTextAttributes = ([NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        //设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
    
}

// MARK: -- tableView数据源方法

extension ZSBaseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    //在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 判断indexpath是否是最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            print("开始刷新")
            loadData()
        }
    }
}
