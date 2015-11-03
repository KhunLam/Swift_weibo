//
//  LKHomeTitleButton.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/2.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKHomeTitleButton: UIButton {

    //重写 布局方法
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 改变箭头位置
        titleLabel?.frame.origin.x = 0
        
        imageView?.frame.origin.x = titleLabel!.frame.width + 5
    }

    
   
}
