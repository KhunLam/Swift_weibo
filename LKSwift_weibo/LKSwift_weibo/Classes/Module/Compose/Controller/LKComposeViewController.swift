//
//  LKComposeViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/4.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 需要设置背景颜色,不然弹出时动画有问题
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
    }
    // MARK: - 准备UI
    private func prepareUI() {
        setupNavigationBar()
    }
    /// 设置导航栏
    private func setupNavigationBar() {
    
        // 设置按钮, 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")

        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false

         setupTitleView()
    
    }

    /// 设置导航栏标题
    private func setupTitleView() {
        //前缀
        let prefix = "发微博"
        // 获取用户的名称
        if let name = LKUserAccount.loadAccount()?.name {
            // 有用户名 "\n"换行
            let titleName = prefix + "\n" + name
            
            // 创建可变的属性文本
            let attrString = NSMutableAttributedString(string: titleName)
            
            // 创建label
            let label = UILabel()
            
            // 设置属性文本
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.systemFontOfSize(16)

            // 获取NSRange
            let nameRange = (titleName as NSString).rangeOfString(name)
            // 设置属性文本的属性  修改用户名 的文本属性
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: nameRange)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: nameRange)
            
            
            // 顺序不要搞错 修改后 先添加文本 再自适应size
            label.attributedText = attrString
            label.sizeToFit()
            
            navigationItem.titleView = label
        }else {
            // 没有用户名
            navigationItem.title = prefix
        }

    
    }
    
    // MARK: - 按钮点击事件
    /// 关闭控制器  若要是私有方法 前面必须加@objc
    @objc private func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 发微博
    func sendStatus() {
        print(__FUNCTION__)
    }

}
