//
//  LKNewFeatureCell.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/1.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

//自定义cell
class LKNewFeatureCell: UICollectionViewCell {

    // MARK: 属性
    // 监听属性值的改变, cell 即将显示的时候会调用
    var imageIndex: Int = 0 {
        didSet {
            // 知道当前是哪一页
            // 设置图片
            backgroundImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            // 每一页都会有按钮  所以要隐藏  要最后一页在动画显示
            startButton.hidden = true
        }
    }

    
    // MARK: - 开始按钮显示动画
    func startButtonAnimation() {
        // 不隐藏
        startButton.hidden = false
        // 把按钮的 transform 缩放设置为0
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 动画 显示出来
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
        }
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    // MARK: - 准备UI
    private func prepareUI() {
    
        // 添加子控件
        contentView.addSubview(backgroundImageView)
         contentView.addSubview(startButton)
        
          // 为地图添加约束 直接Frame就行
//        backgroundImageView.frame = self.bounds
    
        // 添加约束
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        // VFL
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
//        
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        
        backgroundImageView.ff_Fill(contentView)
        
        
        // 开始b
//        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
        
        startButton.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    
    // MARK: - 懒加载
    /// 背景
    private lazy var backgroundImageView = UIImageView()
    
    
    /// 开始体验按钮
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮背景
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置文字
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        // 添加点击事件
        button.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    //MARK: -点击事件 --- 转入主界面
    func startButtonClick() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
    }


}
