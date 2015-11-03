//
//  UIBarButtonItem+Extension.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/1.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

// 拓展  UIBarButtonItem
extension UIBarButtonItem {

    
    /// 需要创建对象 才生成  一个带按钮的UIBarButtonItem
    class func navigaitonItem(imageName: String) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
    
    // 所以 用构造方法  扩展便利的构造函数
    /**
    给 图按钮背景图 名
    - returns: 返回 带有图的按钮
    */
    convenience init(imageName: String) {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        self.init(customView: button)
    }

}
