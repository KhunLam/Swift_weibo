//
//  UIColor+Extension.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/1.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit


// 扩展UIColor的功能.
extension UIColor {
   
    /// 返回一个随机色
    class func randomColor() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    
    /// 随机 0 - 1 的值
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }

}