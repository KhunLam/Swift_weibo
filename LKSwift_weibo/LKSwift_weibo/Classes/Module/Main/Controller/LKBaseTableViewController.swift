//
//  LKBaseTableViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/27.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKBaseTableViewController: UITableViewController {
    //是否登录了
    let userLogin = LKUserAccount.userLogin()

    /*
    // 当实现这个方,并且给view设置值,不会再从其他地方加载view.xib storyboard
    在 loadView，如果:
    1.设置view的值,使用设置的view
    2.super.loadView() 创建TableView
    */
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }

    
//     创建访客视图
        func setupVisitorView() {
//            得到访客视图
            let vistorView = LKVistorView()
            view = vistorView
            // 设置代理
                    vistorView.vistorViewDelegate = self
            // 设置导航栏
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewRegistClick")

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewLoginClick")
    
            /**
            *  判断是那个界面  使用的图片个文字
            */
        if self is LKHomeTableViewController {
            vistorView.startRotationAnimation()
            // 监听应用退到后台,和进入前台
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        }
        else if self is LKMessageTableViewController {
            vistorView.setupVistorView("visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        } else if self is LKDiscoverTableViewController {
            vistorView.setupVistorView("visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        } else if self is LKProfileTableViewController {
            vistorView.setupVistorView("visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
 
    }
    // MAKR: - 通知方法
    func didEnterBackground() {
        // 暂停动画
        print(__FUNCTION__)

        (view as! LKVistorView).pauseAnimation()
    }
    
    func didBecomeActive() {
        // 继续动画
        print(__FUNCTION__)

        (view as! LKVistorView).resumeAnimation()
    }

    
}
// MARK: - 扩展 CZBaseTableViewController 实现 CZVistorViewDelegte 协议
//相当于 category, 方便代码的管理
extension LKBaseTableViewController: LKVistorViewDelegate {
    // MARK: - 代理方法
    func vistorViewRegistClick() {
        print(__FUNCTION__)
    }

    func vistorViewLoginClick() {
        
        // 加载授权界面
        let controller = LKOauthViewController()
        
        presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}
