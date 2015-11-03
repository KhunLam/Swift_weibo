//
//  LKHomeTableViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/26.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SVProgressHUD

// 统一管理cell的ID
enum LKStatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
}


class LKHomeTableViewController: LKBaseTableViewController {

    // MARK: - 属性
    /// 得到微博模型数组
    private var statuses: [LKStatus]? {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if !LKUserAccount.userLogin() {
            return
        }
        //设置导航栏
        setupNavigaiotnBar()
        // talbeView注册cell
        prepareTableView()
        
        LKStatus.loadStatus { (statuses, error) -> () in
            if error != nil {
                // 能到下面来说明有错误
                SVProgressHUD.showErrorWithStatus("加载微博数据失败,网络不给力", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            if statuses == nil || statuses?.count == 0 {
                // 能到下面来说明没有数据
                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 有微博数据
            self.statuses = statuses
//            print("statuses: \(statuses)")

        }
        
    }
    
    // MARK: - tableView 代理和数据源
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取模型
        let status = statuses![indexPath.row]
        
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellID()) as! LKStatusCell
        
        cell.status = status
        
        return  cell
        
    }
    
    // 返回cell的高度   -->如果每次都去计算行高,消耗性能,缓存行高,将行高缓存到模型里面
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 使用 这个方法,会再次调用 heightForRowAtIndexPath,造成死循环
        //        tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // 获取模型
        let status = statuses![indexPath.row]
       
        // 去模型里面查看之前有没有缓存行高
        if let rowHeight = status.rowHeight {
//             print("返回cell: \(indexPath.row), 缓存的行高:\(rowHeight)")
            // 模型有缓存的行高 直接返回
            return rowHeight
        }
        // 没有缓存的行高  ---> 计算行高 再添加到缓存
        
        //根据模型里地retweeted_status 判断是否为转发微博
         let id = status.cellID()
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(id) as! LKStatusCell
    
        // 去模型里面查看之前有没有缓存行高
        let rowHeight = cell.rowHeight(status)
//        print("返回cell: \(indexPath.row), 计算的行高:\(rowHeight)")
        
        // 将行高缓存起来
        status.rowHeight = rowHeight
        
        return rowHeight
    
    }
    
    
    
    //MARK: - talbeView注册自定义cell
    private func prepareTableView() {
        // talbeView注册 原创微博cell
        tableView.registerClass(LKStatusNormalCell.self, forCellReuseIdentifier: LKStatusCellIdentifier.NormalCell.rawValue)
        
        // 转发微博cell
        tableView.registerClass(LKStatusForwardCell.self, forCellReuseIdentifier: LKStatusCellIdentifier.ForwardCell.rawValue)
        
        // 去掉tableView的分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        tableView.rowHeight = 200
        // 设置预估行高
//        tableView.estimatedRowHeight = 300
        // AutomaticDimension 根据约束自己来设置高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        
         // 当配图的高度约束修改后,添加bottomView的底部和contenView底部重合,导致系统计算cell高度约束出错.不能让系统来根据子控件的约束来计算contentView高度约束
    }
    
    
    //MARK: -设置导航栏
    /// 设置导航栏
    private func setupNavigaiotnBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 获取用户名
        // ??:  如果?? 前面有值,拆包 赋值给 name,如果没有值 将?? 后面的内容赋值给 name
        let name = LKUserAccount.loadAccount()?.name ?? "没有名称"
        // 设置title
        let button = LKHomeTitleButton()
        
        button.setTitle(name, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        // 字体颜色
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        // 自动填充
        button.sizeToFit()
        
        button.addTarget(self, action: "homeButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.titleView = button
    }
    
//private私自方法 若要 OC方法（如点击方法）可以访问 要加@objc
 @objc private func homeButtonClick(button: UIButton){
//        print("homeButtonClick")
    
        // 记录按钮箭头的状态  或直接点击后   状态取反
    
    //        if button.selected {
    //            button.selected = false
    //        } else {
    //            button.selected = true
    //        }
         button.selected = !button.selected
    
    // 判断 selected = true 将箭头转到上面
    //        if button.selected {
    //               动画特性
    //            // UIView动画,就近. 270 = 360 - 90，就近转90
    //            // 当两边一样远的时候顺时针.
    //
    //            UIView.animateWithDuration(0.25, animations: { () -> Void in
    //                button.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01))
    //            })
    //        } else {
    //            UIView.animateWithDuration(0.25, animations: { () -> Void in
    //                button.imageView?.transform = CGAffineTransformIdentity
    //            })
    //        }
    // 简单 旋转方法  先定义一个 属性 记录
    var transform: CGAffineTransform?
    if button.selected {
        transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.00001))
    } else {
        transform = CGAffineTransformIdentity
    }
    // 动画
    UIView.animateWithDuration(0.25) { () -> Void in
        button.imageView?.transform = transform!
        
    }
    
    }
    
}
