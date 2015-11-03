//
//  LKWelcomeViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/1.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SDWebImage

class LKWelcomeViewController: UIViewController {

    // MARK: - 属性
    /// 头像底部约束
    private var iconViewBottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加约束
        prepareUI()
        //拿到 用户返回的 头像地址  修改iconVIew
        if let urlString = LKUserAccount.loadAccount()?.avatar_large {
            // 设置用户的头像  --SDW --//  地址        头像 占位图
            iconView.lk_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "avatar_default_big"))
        }


    }
    ///View 出来了 能看见 再做动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        // 开始动画   修改 底部约束 constant 值 改为头像底部距离 View头160  向上移动 用-
        iconViewBottomCons?.constant = -(UIScreen.height() - 160)
        //添加动画
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
              // 重新布局
              self.view.layoutIfNeeded()
            }) { (_) -> Void in
                // 动画完成后再添加动画 显示 欢迎归来
                 UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.welcomeLabel.alpha = 1
                    }, completion: { (_) -> Void in
                   // 动画 彻底完成 --->进入 下一个界面 （主界面）
                    (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
                 })
        }
    }
    
    
    /// MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(backgorundImageView)
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        // 添加约束
        backgorundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        // 背景
        // 填充父控件 VFL
        /*
        H | 父控件的左边 | 父控件的右边
        V | 父控件的顶部 | 父控件的底部
        */
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgorundImageView]))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgorundImageView]))
        
        backgorundImageView.ff_Fill(view)
        
        // 头像
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
//        
//        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))

    // 垂直 底部160 ---属性   修改它 就能做动画效果  原来在距离View底部 160的地方
//       iconViewBottomCons = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160)

//        view.addConstraint(iconViewBottomCons!)
       
        // 内部: ff_AlignInner, 中间下边: ff_AlignType.BottomCenter
        // 返回所有的约束
        let cons =  iconView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSize(width: 85, height: 85), offset: CGPoint(x: 0, y: -160))
        // 在所有的约束里面查找某个约束
        // iconView: 获取哪个view上面的约束
        // constraintsList: iconView上面的所有约束
        // attribute: 获取的约束
        iconViewBottomCons = iconView.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)

     
        // 欢迎归来   ---跟随 头像（在其底部 有一点间距）
        // H
//        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
         welcomeLabel.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 16))

    }
    
    
    // MARK: - 懒加载
    /// 背景
    private lazy var backgorundImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    /// 头像
    private lazy var iconView: UIImageView = {
        // 头像 占位图
        let imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        // 切成圆
        imageView.layer.cornerRadius = 42.5
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    /// 欢迎归来
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "欢迎归来"
        
        label.alpha = 0
        
        return label
    }()

}
