//
//  AppDelegate.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/26.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print("启动 account:\(LKUserAccount.loadAccount())")
        
        setupAppearance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
//        let tabbar = LKMainTabBarViewController()
//          let tabbar = LKWelcomeViewController()
//        let tabbar = LKNewFeatureCollectionViewController()
            let tabbar = defaultController()
        
        
        // ?: 如果?前面的变量有值才执行后的代码
        window?.rootViewController = tabbar
        // 称为主窗口并显示
        window?.makeKeyAndVisible()
         print(isNewVersion())
        return true
    }
    //MARK: - 判断是否登录
    private func defaultController() -> UIViewController {
        // 判断是否登录
        // 每次判断都需要 == nil
        if !LKUserAccount.userLogin() {
            // 没有登录 -> 到主界面（）->没登录 是访客视图  -> 授权界面  登录
            return LKMainTabBarViewController()
        }
        
        // 判断是否是新版本  -->  新特性  或 欢迎界面
        return isNewVersion() ? LKNewFeatureCollectionViewController() : LKWelcomeViewController()
    }

    // MARK: - 切换根控制器
    
    /**
    切换根控制器
    - parameter isMain: true: 表示切换到 MainViewController, false: welcome
    */
    func switchRootController(isMain: Bool) {
        window?.rootViewController = isMain ? LKMainTabBarViewController() : LKWelcomeViewController()
    }

    

    
    /// 判断是否是新版本
    private func isNewVersion() -> Bool {
        // 获取当前的版本号  -->强转为 String 类型
        let versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
      
        // 强转拆包为 Double类型
        let currentVersion = Double(versionString)!
        print("currentVersion: \(currentVersion)")
    
        // 获取到之前的版本号  
        //  设置key
         let sandboxVersionKey = "sandboxVersionKey"
        // 通过key 取得 之前保存的版本号
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        print("sandboxVersion: \(sandboxVersion)")
        
        // 保存当前版本号  并同步一下
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 对比 返回
        return currentVersion > sandboxVersion
    }
    
    /// 导航栏属性
    private func setupAppearance(){
        // 尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    
  
}

