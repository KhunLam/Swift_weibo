//
//  UILabel+Extension.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

/// 扩展UILabel
extension UILabel {
    
    convenience init(fonsize: CGFloat, textColor: UIColor) {
        // 调用本类的指定构造函数
        self.init()
        // 设置文字颜色
        self.textColor = textColor
        
        // 设置文字大小
        font = UIFont.systemFontOfSize(fonsize)
    }
}
