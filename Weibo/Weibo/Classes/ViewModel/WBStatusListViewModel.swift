//
//  WBStatusListViewModel.swift
//  Weibo
//
//  Created by zhi on 2018/7/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
import SDWebImage
//微博数据列表视图模型
// 负责微博数据的处理

class WBStatusListViewModel{
    
    //微博视图模型数组懒加载
  lazy var statusList = [WBStatusViewModel]()
    //上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    // 上拉刷新最大尝试次数
    private let maxPullupTryTimes = 3

    // 是否需要刷新数据笔记
    
    func loadStatus(pullup:Bool,compeltion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) ->()){
        
        //判断是否是上拉刷新，同时检测刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTimes{
            compeltion(true,false)
            return
        }
        //since_id 取出数组中的第一条微博的id，下拉刷新
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        //上拉刷新,取出数组中的最后一条微博
        let max_id = !pullup  ? 0 : (statusList.last?.status.id  ?? 0 )
        ZSNetworkManager.shared.statusList(since_id:since_id,max_id: max_id) { (list, isSuccess) in
            
            //0. 判断网络请求是否成功
            if !isSuccess{
                //直接回调返回
                compeltion(false,false)
                return
            }
            
            //字典转模型(第三方框架都支持嵌套的字典转模型)
            // 定义结果 可变数组
//            var array = [WBStatusViewModel]()
            // 遍历数组 字典转模型 -> 视图模型， 讲视图模型添加到数组
//            for dict in list ?? []{
////                //创建微博模型
////                guard  let model = ZSWBStatus.yy_model(with: dict) else{
////                    continue
////                }
////                //将model 添加到数组
////                array.append(WBStatusViewModel(model: model))
//
//                //创建微博模型
//                let status = ZSWBStatus()
//                //使用字典设置模型数值
//                status.yy_modelSet(with: dict)
//                //使用 微博 模型创建 微博视图 模型
//                let viewModel = WBStatusViewModel(model: status)
//                //添加到数组
//                array.append(viewModel)
//            }
            
            // 1. 遍历字典数组，字典转 模型 => 视图模型，将视图模型添加到数组
            var array = [WBStatusViewModel]()
            for dict in list ?? [] {
                        
                // 1> 创建微博模型
                let status = ZSWBStatus()
                
                // 2> 使用字典设置模型数值
                status.yy_modelSet(with: dict as [AnyHashable : Any])
                
                // 3> 使用 `微博` 模型创建 `微博视图` 模型
                let viewModel = WBStatusViewModel(model: status)
                
                // 4> 添加到数组
                array.append(viewModel)
            }
            //字典转模型
            guard (NSArray.yy_modelArray(with: ZSWBStatus.self, json: list ?? []) as? [ZSWBStatus]) != nil else {
                // 字典转模型失败的情况下会进入
                compeltion(isSuccess, false)
                return
            }
            print("刷新到的数据",array.count)
            //拼接数据
            //下拉刷新，把数组拼接到数组前面
            
            //拼接数据
            if pullup{
                //上拉刷新
                  self.statusList += array
            }else{
                   self.statusList = array + self.statusList
            }
            
            // 判断上拉刷新的数据量
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                compeltion(isSuccess, false)
            }else{
                self.cacheSingleImage(list: array, compeltion: compeltion)
                //真正有数据进行回调
//                compeltion(isSuccess,true)
            }
        }
    }
        
    /// 缓存本次下载微博数据数组中的单张图片
    /// 应该缓存完成单张图像，并且修改过配图的大小之后再回调，才能够保证表格等比例显示单张图片
    /// 闭包可以当作参数传递
    /// - Parameter list: 本次下载的视图模型数组
    
    private func cacheSingleImage(list: [WBStatusViewModel],compeltion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) ->()){
        
        //调度组
        let group = DispatchGroup()
        //记录数据长度
        var length = 0
        //遍历数组，查找微博数据中有单张图像，进行缓存
        for vm in list {
            //判断图像数量
            if vm.picURLS?.count != 1 {
                continue
            }
            //获取图像模型,确定要缓存图片的URL
            guard let pic = vm.picURLS![0].thumbnail_pic,let url = URL(string: pic) else{
                continue
            }
            
            // 入组
            group.enter()
            //FIXME:--- 这里有问题
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                
                //将图像转换成二进制数据
                if let image  = image,
                    let data:Data = UIImage.pngData(image)(){
                    length += data.count
                    
                    //缓存图片
                    vm.updateSingleImageSize(image: image)
                }
                print("缓存的长度\(length)")
                //出组
                group.leave()
            }
        }
        
        //监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            ///执行闭包回调
            compeltion(true,true)
        }
    }
}
