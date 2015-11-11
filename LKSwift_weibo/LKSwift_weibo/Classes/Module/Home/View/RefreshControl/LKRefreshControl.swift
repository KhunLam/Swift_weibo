//
//  LKRefreshControl.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/4.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKRefreshControl: UIRefreshControl {
   
    // MARK: - 属性
    // 下拉时 Frame的Y值一直在改变 是负数 控件高度是60
    // 箭头旋转的值
    private let RefreshControlOffest: CGFloat = -60
    // 标记属性, 用于除去重复答应 
    private var isUp = false
    /// 覆盖父类的frame属性
    override var frame: CGRect {
        didSet {
//            print("frame:\(frame)")
            
            if frame.origin.y >= 0 {
                return
            }
            // 判断系统的刷新控件是否正在刷新
            if refreshing {
                // 调用自定义的view,开始旋转
//                refreshView.startLoading()
            }
            // !isUp表示之前是朝下的
            if frame.origin.y < RefreshControlOffest && !isUp {
//                print("箭头向上")
                isUp = true
                refreshView.rotationTipViewIcon(isUp)
            } else if frame.origin.y > RefreshControlOffest && isUp {   // 0 - 60
//                print("箭头向下")
                isUp = false
                refreshView.rotationTipViewIcon(isUp)
            }
            
            // 判断系统的刷新控件是否正在刷新
            if refreshing {
                // 调用自定义的view,开始旋转
                refreshView.startLoading()
            }


        }
    }
    
    // 重写 endRefreshing
    override func endRefreshing() {
        super.endRefreshing()
        
        // 停止旋转
        refreshView.stopLoading()
    }

    
    //MARK: -//构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   override init() {
        super.init()
        prepareUI()
    }

    func prepareUI(){
        // 添加子控件
        addSubview(refreshView)
        print("refreshView:\(refreshView)")
        
        // 添加约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    
    }
    
    
    
    // MARK: - 懒加载
    /// 自定的刷新view, 从xib里面加载出来view的fram就有了
  private lazy var refreshView: LKRefreshView = LKRefreshView.refreshView()
}

// 自定义刷新的view
class LKRefreshView: UIView{
    
    //箭头
@IBOutlet weak var tipViewIcon: UIImageView!
    // 下拉隐藏
    @IBOutlet weak var tipView: UIView!
     /// 旋转的view//
    @IBOutlet weak var loadingIcon: UIImageView!
    /**
     箭头旋转动画
     - parameter isUp: true,表示朝上, false,朝下
     */
    func rotationTipViewIcon(isUp: Bool) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.tipViewIcon.transform = isUp ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        }

    }
    
    /// 开始旋转
    func startLoading() {
        // 如果动画正在执行,不添加动画
        let animKey = "animKey"
        // 获取图层上所有正在执行的动画的key
        if let _ = loadingIcon.layer.animationForKey(animKey) {
            // 找到对应的动画,动画正在执行,直接返回
            return
        }

        
        // 下拉隐藏
         tipView.hidden = true
        
        // 旋转
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = M_PI * 2
        anim.duration = 0.25
        anim.repeatCount = MAXFLOAT
        // 切换到其它界面 进来会停止  要设为false
        anim.removedOnCompletion = false
        
        // 开始动画,如果名称一样,会先停掉正在执行的,在重新添加
        loadingIcon.layer.addAnimation(anim, forKey: animKey)

    }
    
    /// 停止旋转
    func stopLoading() {
        // 显示tipView
        tipView.hidden = false
        
        // 停止旋转
        loadingIcon.layer.removeAllAnimations()
        
    }
    
    // 加载xib
    class func refreshView() -> LKRefreshView {
        return NSBundle.mainBundle().loadNibNamed("RefreshView", owner: nil, options: nil).last as! LKRefreshView
    }

}