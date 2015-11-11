//
//  LKPhotoBrowserModalAnimation.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/11.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKPhotoBrowserModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    // 自定义动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
       
        // 获取modal出来的控制器的view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 让图片View 隐藏  动画显示出来
        toView.alpha = 0

        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        
        
        // 获取Modal出来的控制器
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! LKPhotoBrowserViewController
        
        // 获取过渡的视图
        let tempImageView = toVC.modalTempImageView()
        
        // TODO: 测试,添加到window上面
        //        UIApplication.sharedApplication().keyWindow?.addSubview(tempImageView)
        transitionContext.containerView()?.addSubview(tempImageView)
        
        // 隐藏collectionView
        toVC.collectionView.hidden = true
        
        
        // 动画
        UIView.animateWithDuration(transitionDuration(nil), animations: { () -> Void in
            // 设置透明
            toView.alpha = 1
            
            // 设置过渡视图的frame 移动到这里
            tempImageView.frame = toVC.modalTargetFrame()
            
            }) { (_) -> Void in
                
                // 移除过渡视图
                tempImageView.removeFromSuperview()
                
                // 显示collectioView
                toVC.collectionView.hidden = false
                
                // 转场完成
                transitionContext.completeTransition(true)
        }

    
    }
    
    
}
