//
//  UIImage+Scale.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/11.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import Foundation


import UIKit

extension UIImage {
    
    /*
    将图片等比例缩放, 缩放到图片的宽度等屏幕的宽度
    */
    func displaySize() -> CGSize {
        // 新的高度 / 新的宽度 = 原来的高度 / 原来的宽度
        
        // 新的宽度
        let newWidth = UIScreen.width()
        
        // 新的高度
        let newHeight = newWidth * size.height / size.width
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        return newSize
    }
}
