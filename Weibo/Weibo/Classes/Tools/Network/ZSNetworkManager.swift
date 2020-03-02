//
//  ZSNetworkManager.swift
//  Weibo
//
//  Created by zhi on 2018/7/23.
//  Copyright © 2018年 ZS. All rights reserved.
//



import UIKit
import AFNetworking

/// swift 枚举支持所有数据类型
enum WBHTTPMethod {
    case GET
    case POST
}

class ZSNetworkManager: AFHTTPSessionManager {
    ///静态区/常量/闭包
    ///在第一次访问时，执行闭包,将结果保存在shared常量中
//    static let shared = ZSNetworkManager()
    //FIXME: --这里有问题
    //static let shared: ZSNetworkManager  {
  static var shared: ZSNetworkManager  {
        // 实例化对象
        let instance = ZSNetworkManager()
        
        //设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //返回对象
        return instance
    }
    //登录访问令牌
    // 用户账户的懒加载属性
    lazy var userAccount = ZSUserAccountModel()
    // 用户登录标记【计算型号属性】
    var userLogon: Bool {
//        return accessToken != nil
        return userAccount.access_token != nil
    }

    //专门拼接Token请求的方法
    func tokenRequest(method:WBHTTPMethod = .GET,url:String,params:[String:AnyObject]?, name: String? = nil, data: Data? = nil,completion:@escaping (_ json:AnyObject?,_ isSuccess:Bool)->()){
        // 1. 判断Token是否为nil
        //FIXME: --发送通知，需要处理没有token的转改
        guard let token =  userAccount.access_token else {
            print("没有Token需要重新登录")
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: WBUserShouldLoginNotification)))
            completion(nil ,false)
            return
        }
       
        
        //判断参数字典是否存在，如果为nil新建一个token
        var params = params
        if params == nil{
            params = [String: AnyObject]()
        }
        
        //设置参数字典,代码在此处字典一定有值
        params!["access_token"] = token as AnyObject 
        //调用request发送网络请求方法
//        request(url: url, params: params, completion: completion)
        
        //判断name 和 data
        if let name = name, let data = data{
            upload(URLString: url, params: params, name: name, data: data, completion: completion)
        }else{
            request(method: method, url: url, params: params, completion: completion)

        }
    }
    
    //上传文件
    
    /// 上传文件
    /// - Parameters:
    ///   - URLString: <#URLString description#>
    ///   - params: <#params description#>
    ///   - name: 接收上传数据的服务器字段
    ///   - data: 上传的二进制数据
    ///   - completion: <#completion description#>
    func upload(URLString: String,params:[String:AnyObject]?, name: String,data: Data,completion:@escaping (_ json:AnyObject?,_ isSuccess:Bool)->()){
        
        //创建FormData
        // 1. data要上传的二进制数据
        // 2. name: 服务器接收数据的字段名
        // 3.filename: 保存在服务器的文件名，大多数可以乱写
        // 4. mineType: 告诉服务器上传文件的类型
        post(URLString, parameters: params, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, json) in
            completion(json! as AnyObject,true)
        }) { (task, error) in
            //父类往子类转的话需要用 as转换
           if  (task?.response as? HTTPURLResponse )?.statusCode == 403{
            //谁接收到通知，谁处理
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token", userInfo: nil)
                print("token过期了")
            }
        }
        
    }
    
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - parameter method: GET / POST
    /// - parameter URLString: URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典／数组), 是否成功]
    func request(method:WBHTTPMethod = .GET,url:String,params:[String:AnyObject]?,completion:@escaping (_ json:AnyObject?,_ isSuccess:Bool)->()){
        
        let success = {(task:URLSessionDataTask,json:Any?)->() in
            completion(json! as AnyObject,true)
        }
        let failure = {(task:URLSessionDataTask?,error:Error)->() in
            print("网络请求错误\(error)")
            //父类往子类转的话需要用 as转换
           if  (task?.response as? HTTPURLResponse )?.statusCode == 403{
            //谁接收到通知，谁处理
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token", userInfo: nil)
                print("token过期了")
            }
            completion(nil, false)
        }
        if method == .GET {
            get(url, parameters: params, progress: nil, success:success, failure: failure )
        } else {
            post(url, parameters: params, progress: nil, success: success, failure: failure)
        }
    }
}
