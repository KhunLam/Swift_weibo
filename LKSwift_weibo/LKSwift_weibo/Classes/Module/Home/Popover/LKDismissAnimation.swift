//
//  LKDismissAnimation.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/10.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
/// dismiss动画类
class LKDismissAnimation: NSObject,UIViewControllerAnimatedTransitioning {

    
    // 返回 动画 时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }

    
    // 在这个方法里面实现动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
       
        // 获取到modal出来的控制器的view  --用From 拿到弹框 控制器
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        ///用一个普通 动画 dismiss
//        UIView.animateWithDuration(transitionDuration(nil), animations: { () -> Void in
//            /// dismiss 就是把 它的 缩放比例 y轴的 改为 接近0
//            fromView?.transform = CGAffineTransformMakeScale(1, 0.01)
//            
//            }) { (_) -> Void in
//                transitionContext.completeTransition(true)
//        }
//       
              ///弹簧 动画 dismiss
                UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    // 将formView的Y方向的scale设置为0
                    fromView?.transform = CGAffineTransformMakeScale(1, 0.01)
                    }) { (_) -> Void in
                        // 一定要记得告诉系统,转场完成
                        transitionContext.completeTransition(true)
                }

    
    }
    
    
}
