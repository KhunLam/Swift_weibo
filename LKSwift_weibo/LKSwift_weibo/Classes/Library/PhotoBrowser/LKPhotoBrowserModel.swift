//
//  LKPhotoBrowserModel.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/10.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
// 图片模型  --- 最好有图片的所有信息
class LKPhotoBrowserModel: NSObject {

    ///在 配图里 拿到对应 点击的图片
    
    // MARK: - 属性
    /// 大图的url
    var url: NSURL?
    
    /// 对应小图的Imageview
    var imageView: UIImageView?
    
    
}
