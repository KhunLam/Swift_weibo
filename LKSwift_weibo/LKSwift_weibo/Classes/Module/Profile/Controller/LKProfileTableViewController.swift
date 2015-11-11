//
//  LKProfileTableViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/26.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class LKProfileTableViewController: LKBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 获取SDWebImage缓存图片的大小
        let size = Double(SDImageCache.sharedImageCache().getSize()) / 1000.0 / 1000.0
         // 两位小数 --swift写法
        let newSize = String(format: "%.2f", arguments: [size])
        
        navigationItem.title = "缓存大小:\(newSize) M"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清除缓存", style: UIBarButtonItemStyle.Plain, target: self, action: "clear")
        
    }
    
    func clear() {
        SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
//            print("清除缓存完成")
             SVProgressHUD.showInfoWithStatus("清除缓存完成", maskType: SVProgressHUDMaskType.Black)
            
            /// 重新计算 缓存
            // 获取SDWebImage缓存图片的大小
            let size = Double(SDImageCache.sharedImageCache().getSize()) / 1000.0 / 1000.0
             // 两位小数 --swift写法
            let newSize = String(format: "%.2f", arguments: [size])
            self.navigationItem.title = "缓存大小:\(newSize) M"
        }
    }

}
