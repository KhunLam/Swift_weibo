//
//  LKModalAnimation.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/10.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

/// model 动画类
class LKModalAnimation: NSObject,UIViewControllerAnimatedTransitioning {

    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    /*
    当实现这个方法,model出来的控制器的view是需要我们自己添加到容器视图
   
    transitionContext:
    转场的上下文.提供转场相关的元素
    
    containerView():
    容器视图
    
    completeTransition:
    当转场完成一定要调用,否则系统会认为转场没有完成,不能继续交互
    
    viewControllerForKey(key: String):
    拿到对应的控制器:
    modal时:
    UITransitionContextFromViewControllerKey: 调用presentViewController的对象
    UITransitionContextToViewControllerKey:
    modal出来的控制器
    
    viewForKey
    拿到对应的控制器的view
    UITransitionContextFromViewKey ---From 之前的控制器
    UITransitionContextToViewKey   ---To   出现的控制器

     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        // 将modal出来的控制器的view添加到容器视图  --用To拿到弹框控制器
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 设置缩放比例 让y先等于0  动画为 CGAffineTransformIdentity（原来）
        toView.transform = CGAffineTransformMakeScale(1, 0)
        // 改变锚点  （原来是 中心向两边动画） 让它由上往下打开
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        
        UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 转场完成  一定要调用
                transitionContext.completeTransition(true)
        }
    }
    
}
