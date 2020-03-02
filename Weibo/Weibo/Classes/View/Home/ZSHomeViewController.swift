//
//  ZSHomeViewController.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit

//  定义全局常量， 尽量使用`private`去修饰
private let originalId = "originalId"
private let retweetedCellId = "retweetedCellId"  //可复用的ID


class ZSHomeViewController: ZSBaseViewController {

    //weibo数据
//    private lazy var statusList = [String]()
    private lazy var listViewModel = WBStatusListViewModel()
    
    // 加载数据
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
           print("结束刷新")
           //结束刷新控件
           self.refreshControl?.endRefreshing()
           // 恢复上拉刷新标记
           self.isPullup = false
           self.tableView?.reloadData()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    @objc private func showFriends () {
        print(#function)
        let demoVc = ZSDemoViewController()
        demoVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(demoVc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: -- 表格数据源方法, 具体数据源方法，不需要super
extension ZSHomeViewController{
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
  override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    //取出视图模型，根据视图模型判断可重用Cell
     let VM = listViewModel.statusList[indexPath.row]
    let cellId =  (VM.status.retweeted_status != nil) ? retweetedCellId : originalId
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ZSStatusCell
    //设置Cell
    cell.delegate = self
    cell.viewModel = VM
        return cell
    }
    
  override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        //根据indexpath获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        //返回计算好的行高
        return vm.rowHeight
    }
  
}
// MARK:-- 代理协议

extension ZSHomeViewController: WBStatusCellDelegate{
    func statusCellDidSelectedURLString(cell: ZSStatusCell, urlString: String) {
        let vc = ZSWebViewController()
        vc.urlString = urlString
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ZSHomeViewController{
    
    
    @objc override  func setupTableView() {
            super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        // 注册原型Cell
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UINib(nibName: "ZSStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalId)
         tableView?.register(UINib(nibName: "ZSStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        // FIXME: -- 动态行高需要修改
//        tableView?.rowHeight = UITableViewAutomicDimension
        tableView?.estimatedRowHeight = 300
        
        //取消分割线
        tableView?.separatorStyle = .none
        setupNavTitle()
    }
    
    
    //设置导航栏标题
    func setupNavTitle(){
        let title = ZSNetworkManager.shared.userAccount.screen_name
        
        let button = ZSTitleButton(title: title)
//        button?.setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
//        button?.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        navItem.titleView = button
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc func clickTitleButton(btn: UIButton){
        //设置选中状态
        btn.isSelected = !btn.isSelected
    }
}
