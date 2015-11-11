//
//  LKImageView.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/10.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKImageView: UIImageView {

    
    // 覆盖父类的属性
    override var transform: CGAffineTransform {
        didSet{
            // 当设置的缩放比例小于指定的最小缩放比例时.重新设置
            if transform.a < LKPhotoBrowserCellMinimumZoomScale {
                print("设置 transform.a:\(transform.a)")
                transform = CGAffineTransformMakeScale(LKPhotoBrowserCellMinimumZoomScale, LKPhotoBrowserCellMinimumZoomScale)
            }

        }
    }
}
