//
//  ZSUserAccountModel.swift
//  Weibo
//
//  Created by zhi on 2020/2/15.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit
private let accountFile : NSString = "useraccount.json"

class ZSUserAccountModel: NSObject {
    //访问令牌
    @objc var access_token : String?
    //用户代号
   @objc var uid: String?
    //过期日期
    // 开发者是5年，使用者是3天
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //过期日期
   @objc var expiresDate: Date?
    
    // 用户名称
    @objc var screen_name: String?
    //用户头像
    @objc var avatar_large: String?
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        //从磁盘加载保存文件
        //从磁盘加载二进制数据，如果失败直接return
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : AnyObject] else{
            return
        }
             print("存储地址\(path)")
        //使用字典设置属性值
        yy_modelSet(with: dict ?? [:])

        //判断token是否过期
       if  expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
        //清空token
        access_token = nil
        uid = nil
        //删除账户文件
      _ =  try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    
    func saveAccount(){
        //模型转字典
        var  dict = (self.yy_modelToJSONObject() as? [String : AnyObject]) ?? [:]
        print("存下来的数据------ \(dict)")
        //需要删除expires_in  值
        dict.removeValue(forKey: "expires_in")
        // 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),let filePath = accountFile.cz_appendDocumentDir() else{
            return
        }
        // 写入磁盘
        (data as NSData) .write(toFile: filePath, atomically: true)
               print("用户账户保存成功 \(filePath)")
    }
}
