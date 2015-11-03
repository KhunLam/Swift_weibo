//
//  UIImageView+Extension.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

/// 隔离SDWebImage
extension UIImageView {
    
    func lk_setImageWithURL(url: NSURL!) {
        sd_setImageWithURL(url)
    }
    
    func lk_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!) {
        sd_setImageWithURL(url, placeholderImage: placeholder)
    }
}
