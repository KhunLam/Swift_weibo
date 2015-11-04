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
        

        
      //        loadData()
        //刷新控件  高度默认60
        // 自定义 UIRefreshControl,在 自定义的UIRefreshControl添加自定义的view
//        refreshControl = UIRefreshControl()
        refreshControl = LKRefreshControl()
        
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        // 调用beginRefreshing开始刷新,但是不会触发 ValueChanged 事件,只会让刷新控件进入刷新状态 --不会触发
        refreshControl?.beginRefreshing()
        // 刚进入界面 主动代码触发 refreshControl 的 ValueChanged 事件
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    //MARK: - 加载数据
    func loadData(){
        // 默认下拉刷新,获取id最大的微博, 如果没有数据,就默认加载20
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 如果上拉菊花正在转,表示 上拉加载更多之前的数据
        if pullUpView.isAnimating() {
            // 上拉加载更多数据
            since_id = 0
            max_id = statuses?.last?.id ?? 0 // 设置为最后一条微博的id
        }

         //模型返回数据
        LKStatus.loadStatus(since_id, max_id: max_id){ (statuses, error) -> () in
            
             //加载到数据 就 关闭下拉刷新控件
            self.refreshControl?.endRefreshing()
            
            //加载到数据 就将 上拉菊花停止
            self.pullUpView.stopAnimating()
            
            if error != nil {
                // 能到下面来说明有错误
                SVProgressHUD.showErrorWithStatus("网络连接失败", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            // 下拉刷新,显示加载了多少条微博
            if since_id > 0 {
                let count = statuses?.count ?? 0
                self.showTipView(count)
            }

            
            if statuses == nil || statuses?.count == 0 {
                // 能到下面来说明没有数据
                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 判断如果是下拉刷新,加获取到数据拼接在现有数据的前
            if since_id > 0 {   // 下拉刷新
                // 最新数据 =  新获取到的数据 + 原有的数据
                print("下拉刷新,获取到: \(statuses?.count)");
               self.statuses = statuses! + self.statuses!
            }else if max_id > 0 {  // 上拉加载更多数据
                // 最新数据 =  原有的数据 + 新获取到的数据
                print("上拉加载更多数据,获取到: \(statuses?.count)");
                self.statuses = self.statuses! + statuses!
            }else{
                 self.statuses = statuses
                 print("获取最新20条数据.获取到 \(statuses?.count) 条微博")
            }
            
            

            
        }

    }
    
    // MARK: - tableView 代理和数据源
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取模型
        let status = statuses![indexPath.row]
        
        // 获取.cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellID()) as! LKStatusCell
        
        cell.status = status
        
        // 当最后一个cell显示的时候来加载更多微博数据
        // 如果菊花正在显示,就表示正在加载数据,就不加载数据
        if indexPath.row == statuses!.count - 1  && !pullUpView.isAnimating() {
            // 上拉菊花转起来
            pullUpView.startAnimating()
            
            // 上拉加载更多数据
            loadData()
        }

        
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
        
        // 添加footView,上拉加载更多数据的菊花
        tableView.tableFooterView = pullUpView

    }
    
    //MARK: -显示下拉刷新加载了多少条微博
    private func showTipView(count: Int) {
       
        let tipLabelHeight: CGFloat = 44
        let tipLabel = UILabel()
        // 它的始起点在 左上角 y为 20 （状态栏下面）
        tipLabel.frame = CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.width(), height: tipLabelHeight)
        
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.font = UIFont.systemFontOfSize(16)
        tipLabel.textAlignment = NSTextAlignment.Center
        
        tipLabel.text = count == 0 ? "没有新的微博" : "加载了 \(count) 条微博"

        // 导航栏是从状态栏下面开始
        // 添加到导航栏最下面
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        //停留时间
        let duration = 0.75
        // 开始动画
        UIView.animateWithDuration(duration, animations: { () -> Void in
            /* 
            让动画反过来执行
            UIView.setAnimationRepeatAutoreverses(true)
            然后在动画后 消除
            tipLabel.removeFromSuperview()
             */
            // 重复执行 UIView.setAnimationRepeatCount(5)
            
            
            tipLabel.frame.origin.y = tipLabelHeight
            
            }) { (_) -> Void in
                
                UIView.animateWithDuration(duration, delay: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
        
                    tipLabel.frame.origin.y = -20 - tipLabelHeight
                    
                    }, completion: { (_) -> Void in
                        
                        tipLabel.removeFromSuperview()
                })
        }
        
        
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
    
    // MARK: - 懒加载
    /// 上拉加载更多数据显示的菊花   ---活动指示器视图（菊花控制器）
    private lazy var pullUpView: UIActivityIndicatorView = {
            //指示器菊花
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        indicator.color = UIColor.magentaColor()
        
        return indicator
    }()

    
}
