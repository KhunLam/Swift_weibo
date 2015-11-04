//
//  LKMainTabBarViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/26.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKMainTabBarViewController: UITabBarController {

    //MARK: -------------------私有属性-------------------
    //MARK: -------------------对外属性-------------------
    //MARK: -------------------对外方法-------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 首页
        let homeVC = LKHomeTableViewController()
        addChildViewController(homeVC, title: "首页", imageName: "tabbar_home")
        
        // 消息
        let messageVC = LKMessageTableViewController()
        self.addChildViewController(messageVC, title: "消息", imageName: "tabbar_message_center")
        
        // 添加撰写控制器（占位）
        let controller = UIViewController()
        self.addChildViewController(controller, title: "", imageName: "")
        
        // 发现
        let discoverVC = LKDiscoverTableViewController()
        self.addChildViewController(discoverVC, title: "发现", imageName: "tabbar_discover")
        
        // 我
        let profileVC = LKProfileTableViewController()
        self.addChildViewController(profileVC, title: "我", imageName: "tabbar_profile")
        // 给tabBar字体 设颜色
        tabBar.tintColor = UIColor.orangeColor()
        
    }
    // View 准备 出现时 为撰写按钮 设Frame
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let width = tabBar.bounds.size.width / CGFloat(5)
        composeButton.frame = CGRect(x: width * 2, y: 0, width: width, height: tabBar.bounds.size.height)
        tabBar.addSubview(composeButton)
        
    }

    //MARK: -------------------私有方法-------------------
    
    /**
     添加子控制器,包装Nav
     - parameter controller: 控制器
     - parameter title:      标题
     - parameter imageName:  图片名称
     */
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
        controller.title = title
        controller.tabBarItem.image = UIImage(named: imageName)
        addChildViewController(UINavigationController(rootViewController: controller))

    }
    
   

    
    //  MARK: - 懒加载
    /// 撰写按钮
   private lazy var composeButton: UIButton = {
        let button = UIButton()
        // 按钮图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 按钮的背景
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "composeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
   

    // MARK - 点击事件
    ///撰写按钮 被点击
     func composeButtonClick() {
        // 判断如果没有登录,就到登陆界面,否则就到发微博界面
        let vc = LKUserAccount.userLogin() ? LKComposeViewController() : LKOauthViewController()
        // 弹出对应的控制器
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    
    }


}
