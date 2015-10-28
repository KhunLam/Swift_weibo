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
        
        setupAppearance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let tabbar = LKMainTabBarViewController()
      
        // ?: 如果?前面的变量有值才执行后的代码
        window?.rootViewController = tabbar
        // 称为主窗口并显示
        window?.makeKeyAndVisible()
        
        return true
    }

    private func setupAppearance(){
        // 尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
  
}

