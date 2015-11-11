//
//  LKPresentationController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/10.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

/*
presentedViewController:
展现的控制器(modal出来的控制器)

presentedView():
返回modal出来的控制器的view

containerView:
容器视图:存放modal出来的控制器的view        --- 缩小它的frame

containerViewWillLayoutSubviews
容器视图布局的时候调用

containerViewDidLayoutSubviews
容器视图布局的完成时候调用   -------会有点瑕疵 动画最好不要完成才布局

presentationTransitionWillBegin
当将要modal时候会调用这个方法
*/

/// 自定义 控制展现(显示) 样式
class LKPresentationController: UIPresentationController {

    // 容器视图将要布局
    override func containerViewWillLayoutSubviews(){
        super.containerViewDidLayoutSubviews()
//        print("containerViewDidLayoutSubviews")
    
        // 容器视图背景改成灰色 0全黑 0.2透明 --灰色
        containerView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        // 创建手势  单击手势
        let tap = UITapGestureRecognizer(target: self, action: "close")
        containerView?.addGestureRecognizer(tap)
    
        // 设置modal出来控制器的view的大小
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 300)
    }
    
    func close() {
        // 拿到modal出来的控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        
        // 让首页的title按钮转回去  取消选中  通知
   NSNotificationCenter.defaultCenter().postNotificationName("PopoverDismiss", object: nil)
   
    }

    
    
}
