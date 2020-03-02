//
//  AppDelegate.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //应用程序额外设置
        setupAdditions()
       
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ZSMainViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK:--- 设置额外信息
extension AppDelegate{
    
    private func setupAdditions(){
        //设置SVProgressHUD最小时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        //设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //设置用户授权通知
         //当前用户中心  10.0以上
                //获取权限 显示通知
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
                    print("授权" + (success ? "成功" : "失败"))
                }
        //        // 10.0以下
        //
        //        let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        //        application.registerUserNotificationSettings(notifySettings)
        //
    }
}

//MARK: -- 加载服务器信息
extension AppDelegate{
    private func loadAppInfo(){
        DispatchQueue.global().async {
            //1.url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
        
            //data
            let data = NSData(contentsOf: url! )
            
        //取沙盒目录
            let doctDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (doctDir as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
            print("应用程序加载完毕 \(jsonPath)")
            
        }
    }
}
