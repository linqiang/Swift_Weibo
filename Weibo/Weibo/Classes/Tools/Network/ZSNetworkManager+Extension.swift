//
//  ZSNetworkManager+Extension.swift
//  Weibo
//
//  Created by zhi on 2018/7/24.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation

extension ZSNetworkManager {
    
    
    func statusList(since_id:Int64 = 0,max_id: Int64 = 0,completion:@escaping (_ list:[[String : AnyObject?]]?, _ isSuccess: Bool) -> ()){

        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        //pullup  ? 0 : (statusList.last?.id  ?? 0 )
        let params = ["since_id" : "\(since_id)","max_id" : "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(url: urlString, params: params as [String : AnyObject]) { (json, isSuccess) in
            //如果从json中获取statuses字典数组，如果as? 失败 reult = nil

             let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
//    // 返回微博的未读数量
    func unreadCount(completion:@escaping (_ count: Int) ->()){
        guard let uid  = userAccount.uid else{
            return
        }
        let urlString = "https://rm.api.weibo.com/remind/unread_count.json"
        let param = ["uid":uid]
        tokenRequest(url: urlString, params:param as [String : AnyObject]) { (json, isSuccess) in
            let dict = json as? [String : AnyObject]
            let count  = dict?["status"] as? Int
            completion(count ?? 0)

        }
    }
}

//MARK: -- 加载用户信息
extension ZSNetworkManager{
    //加载用户信息 ---登录后立即执行
    func loadUerInfo(completion: @escaping (_ dict:[String : AnyObject]) -> ()){
        guard let uid = userAccount.uid else{
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid" : uid]
        
        tokenRequest(url: urlString, params: params as [String : AnyObject]) { (json, isSuccess) in
            completion(json as? [String : AnyObject] ?? [:])
        }
    }
}
//MARK: -- 发布微博
extension ZSNetworkManager{
    
    //发布微博
    func postStatus(statusText: String, image: UIImage?,completion: @escaping (_ result: [String: AnyObject]?,_ isSuccess: Bool) -> ()) ->(){
        // 根据是否有图像，选择不同的接口地址
        let urlString: String
           if image == nil {
               urlString = "https://api.weibo.com/2/statuses/update.json"
           } else {
               urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
           }
        //参数字典
        let params = ["status":statusText]
        // 3. 如果图像不为空，需要设置 name 和 data
          var name: String?
          var data: Data?
          
          if image != nil {
              name = "pic"
            data = image!.pngData()
          }
        //发起网络请求

        tokenRequest(method: .POST, url: urlString, params: params as [String : AnyObject],name: name, data: data) { (json, isSuccess) in
            completion( json as? [String : AnyObject] ,isSuccess)
        }
    }
}

// MARK: -- 获取token
extension ZSNetworkManager{
    //加载AccessToken
    func loadAccessToken(code: String,completion: @escaping (_ isSuccess:Bool) -> ()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":WBAppkey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBRedirectURI]
        
        // 发起网络请求
        request(method: .POST, url: urlString,  params: params as [String : AnyObject]) { (json, isSuccess) in
            
            //如果请求失败，对用户账户数据不会有任何影响
            //直接用字典设置 userAccount 的属性
            //在as前面如果是可选的那么 就使用 as?    、、、  [:]表示空字典
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
           
            
            //加载用户信息
            self.loadUerInfo(completion: {(dict) in
                print(dict)
                // 完成回调在用户信息完成回调之后
                self.userAccount.yy_modelSet(with: dict)
                //保存模型
               self.userAccount.saveAccount()
                completion(true)
            })
          
        }
    }
}
