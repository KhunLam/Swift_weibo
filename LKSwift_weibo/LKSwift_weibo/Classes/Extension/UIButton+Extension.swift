//
//  UIButton+Extension.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//


import UIKit

/// 扩展UIButton
extension UIButton {
    
    /**
     快速创建按钮
     - parameter imageName:  图片名称
     - parameter title:      标题
     - parameter titleColor: 标题颜色
     - parameter fontSize:   标题大小
     - returns: 按钮
     */
    convenience init(imageName: String, title: String, titleColor: UIColor = UIColor.lightGrayColor(), fontSize: CGFloat = 12) {
        self.init()
        
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
