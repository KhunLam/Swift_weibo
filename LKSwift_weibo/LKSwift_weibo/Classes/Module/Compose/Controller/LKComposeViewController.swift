//
//  LKComposeViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/4.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SVProgressHUD

class LKComposeViewController: UIViewController {

    // MARK: - 属性
    /// toolBar底部约束 -- 给外界
    private var toolBarBottomCon: NSLayoutConstraint?
    /// 照片选择器控制器view的底部约束
    private var photoSelectorViewBottomCon: NSLayoutConstraint?

    /// 微博内容的最大长度 (新浪最大字数140)
    private let statusMaxLength = 140
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 需要设置背景颜色,不然弹出时动画有问题
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
     
        
        // 添加键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)

 
    }
//    --- 准备显示 自动弹出键盘
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        // 弹出键盘
    //        textView.becomeFirstResponder()
    //    }
    
    //--- 显示完毕自动弹出键盘
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 自定义 键盘  表情键盘 ---只有高度会有效
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
//        view.backgroundColor = UIColor.redColor()
//        textView.inputView = view
        
      
        // 如果照片选择器的view没有显示就弹出键盘，当有显示（即图片选择器在的时候）不弹出
        if photoSelectorViewBottomCon?.constant != 0 {
            // 自定义键盘其实就是给 textView.inputView 赋值 --- 显示完毕自动弹出键盘
            textView.becomeFirstResponder()
        }
        
    }
    
    
    //MARK: -监听通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
    notification:NSConcreteNotification 0x7ffe62d1a9d0 {name = UIKeyboardWillChangeFrameNotification; userInfo = {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";-------------- // 动画时间
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 271}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 871.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 600.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 736}, {414, 271}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 465}, {414, 271}}";-----// 键盘最终的位置(有用的值)
    UIKeyboardIsLocalUserInfoKey = 1;
    }}

    */
    
    /// 键盘frame改变
    func willChangeFrame(notification: NSNotification) {
        // 打印通知  获取有用的值
//        print("notification:\(notification)")
        
        // 获取键盘最终位置  --NSRect 强转
        let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // 动画时间 -- NSTimeInterval 强转
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
         // 改变约束 constant常数  --toolBar的底部位置  =  高度 减  键盘最终位置的 值   负号 向上移
        toolBarBottomCon?.constant = -(UIScreen.height() - endFrame.origin.y)
         //动画
        UIView.animateWithDuration(duration) { () -> Void in
            // 不要直接更新toolBar的约束 ， 要跟新整个View的约束
            // self.toolBar.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - 准备UI （层次结构要清晰）
    private func prepareUI() {
        
        // 添加子控件
        view.addSubview(textView)//第一个添加的View
        view.addSubview(photoSelectorVC.view)
        view.addSubview(toolBar)
        view.addSubview(lengthTipLabel)

        
        setupNavigationBar()
        setupTextView()
        preparePhotoSelectorView()
        setupToolBar()
        prepareLengthTipLabel()
       
    }
    //MARK: -设置textView
    /// 设置textView
   private func setupTextView(){
    
  
    
    // 添加约束
    // 相对控制器的view的内部左上角
    textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
    // 相对toolBar顶部右上角
    textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)

     /*  知识 拓展
//     textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height-44))
//    automaticallyAdjustsScrollViewInsets = true
   
    前提:
    1.scrollView所在的控制器属于某个导航控制器
    2.scrollView要是 控制器的view或者控制器的view的第一个子view
    所以添加时必须先 添加 setupTextView()  后 添加 setupToolBar()
    */
    // scrollView会自动设置Insets, 比如scrollView所在的控制器属于某个导航控制器contentInset.top = 64  ---默认
    //        automaticallyAdjustsScrollViewInsets = true （默认 true）
    }
    
    //MARK: -照片选择器
    /// 准备 照片选择器
    func preparePhotoSelectorView() {
      
        // 照片选择器控制器的view
        let photoSelectorView = photoSelectorVC.view
       
        
        photoSelectorView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["psv": photoSelectorView]
        // 添加约束
        // 水平
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[psv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 高度
        view.addConstraint(NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 0))
        
        // 底部重合，偏移photoSelectorView的高度
        photoSelectorViewBottomCon = NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: view.frame.height * 0.6)
        view.addConstraint(photoSelectorViewBottomCon!)


    }
    
    
    //MARK: -显示微博剩余长度
    /// 准备 显示微博剩余长度 label
    private func prepareLengthTipLabel() {
        
        // 添加约束
        lengthTipLabel.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil, offset: CGPoint(x: -8, y: -8))
    }

    
    //MARK: -设置toolBar
    /// 设置toolBar
    private func setupToolBar() {
        
        
        // 添加约束
        let cons = toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        
        // 获取底部约束 toolBar.ff_Constraint找所以约束 --- 让toolBar 跟着键盘向上跑
        toolBarBottomCon = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 创建toolBar item 可变数组
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片名称 ，点击事件名称 字典 （小技巧 不用tag要监听点击事件 从字典里取）
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "picture"],
            ["imageName": "compose_trendbutton_background", "action": "trend"],
            ["imageName": "compose_mentionbutton_background", "action": "mention"],
            ["imageName": "compose_emoticonbutton_background", "action": "emoticon"],
            ["imageName": "compose_addbutton_background", "action": "add"]]
        
        
        // 遍历 itemSettings 获取图片名称,创建items
        for dict in itemSettings {
            // 获取图片的名称
            let imageName = dict["imageName"]!
            
            // 获取图片对应点点击方法名称
            let action = dict["action"]!
            
            // 用拓展的 分类方法  直接创建  自带高亮图片
            let item = UIBarButtonItem(imageName: imageName)
            
            // 获取item里面的按钮 -custom自定义- 添加点击方法
            let button = item.customView as! UIButton
            button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
            
            //把创建好的按钮 添加到数组
            items.append(item)
            
            // 添加弹簧 每个按钮后添加一个
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
        }
        
        // 移除最后一个弹簧 -（移除数组最后一个控件）
        items.removeLast()
        
        //设置 toolbar的items
        toolBar.items = items

    }
    //MARK: -设置导航栏
    /// 设置导航栏
    private func setupNavigationBar() {
    
        // 设置按钮, 左边
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")

        // 右边
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false
          // 设置导航栏标题
         setupTitleView()
    
    }
    /// 设置导航栏标题
    private func setupTitleView() {
        //前缀
        let prefix = "发微博"
        // 获取用户的名称
        if let name = LKUserAccount.loadAccount()?.name {
            // 有用户名 "\n"换行
            let titleName = prefix + "\n" + name
            
            // 创建可变的属性文本
            let attrString = NSMutableAttributedString(string: titleName)
            
            // 创建label
            let label = UILabel()
            
            // 设置属性文本
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.systemFontOfSize(16)

            // 获取NSRange
            let nameRange = (titleName as NSString).rangeOfString(name)
            // 设置属性文本的属性  修改用户名 的文本属性
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: nameRange)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: nameRange)
            
            
            // 顺序不要搞错 修改后 先添加文本 再自适应size
            label.attributedText = attrString
            label.sizeToFit()
            
            navigationItem.titleView = label
        }else {
            // 没有用户名
            navigationItem.title = prefix
        }

    
    }
    
    
    
    // MARK: - 导航栏 按钮点击事件
    /// 关闭控制器  若要是私有方法且用了OC的方法 前面必须加@objc
    @objc private func close() {
        
        // 关闭sv提示
        SVProgressHUD.dismiss()
        
        // 有键盘时 退出时 把键盘 移除关闭 --移除第一响应者
        textView.resignFirstResponder()
    
        // 退出控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: -toolBar 按钮点击事件
    func picture() {
        // 让照片选择器的view移动上来
        photoSelectorViewBottomCon?.constant = 0
        
        // 退下键盘
        textView.resignFirstResponder()
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func trend() {
        print("#")
    }
    
    func mention() {
        print("@")
    }
    /*
    1.textView.inputView == nil 弹出的是系统的键盘
    2.正在显示的时候设置 textView.inputView 不会立马起效果
    3.在弹出来之前判断使用什么键盘
    4.先让键盘退出  再进入 frame才有 才有效果
    */
    func emoticon() {
        print("切换前表情键盘:\(textView.inputView)")
        // 先让键盘退回去
        textView.resignFirstResponder()
       
        
        // 延时0.25--int64  250毫秒USEC_PER_SEC
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(250 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in

        // 如果inputView == nil 使用的是系统的键盘,切换到自定的键盘
        // 如果inputView != nil 使用的是自定义键盘,切换到系统的键盘
        self.textView.inputView = self.textView.inputView == nil ? self.emoticonVC.view : nil

        // 弹出键盘
        self.textView.becomeFirstResponder()
          print("切换后表情键盘:\(self.textView.inputView)")
        }
    }
    
    func add() {
        print("加号")
    }

    
    /// 发微博
    func sendStatus() {
//        print(__FUNCTION__)
        // 获取textView的文本内容发送给服务器  --带表情的文本
        let text = textView.emoticonText()
        // 判断微博内容的长度 < 0 不发送
        let statusLength = text.characters.count
        if statusMaxLength - statusLength < 0 {
            // 微博内容超出,提示用户
            SVProgressHUD.showErrorWithStatus("微博长度超出", maskType: SVProgressHUDMaskType.Black)
            return
        }

        // 获取图片选择器中的图片
        let image = photoSelectorVC.photos.first
        
        // 显示正在发送
        SVProgressHUD.showWithStatus("正在发布微博...", maskType: SVProgressHUDMaskType.Black)
        // 发送微博
        LKNetworkTools.sharedInstance.sendStatus(image, status: text) { (result, error) -> () in
            if error != nil {
                print("error:\(error)")
                SVProgressHUD.showErrorWithStatus("网络不给力...", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            // 发送成功, 直接关闭界面
            SVProgressHUD.showErrorWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            self.close()
        }

    }
    
    
    // MARK: - 懒加载
    /// toolBar
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        // 背景弄成 色 让1X图的效果没那么挫
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        return toolBar
    }()


    
    /*
    iOS中可以让用户输入的控件:
    1.UITextField:
    1.只能显示一行
    2.可以有占位符
    3.不能滚动
    
    2.UITextView:
    1.可以显示多行
    2.没有占位符
    3.继承UIScrollView,可以滚动
    */
     ///  输入控件 用UITextView 合适  --要有占位符（利用textview的代理方法 输入时将占位符隐藏） 自定义TextView
    /// textView
    private lazy var textView: LKTextView = {
        let textView = LKTextView()
        
        //设一个模式 当textView被拖动的时候就会将键盘退回,textView能拖动
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        // 能拖到
        textView.alwaysBounceVertical = true
        // 有弹框效果
        textView.bounces = true
        
        //字体 大小 颜色
        textView.font = UIFont.systemFontOfSize(18)
        textView.textColor = UIColor.blackColor()
        //View的底色
        textView.backgroundColor = UIColor.brownColor()
    
        
        // 设置顶部的偏移 （不偏移 头部会被档着）
//        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // 设置占位文本
        textView.placeholder = "分享新鲜事..."
        
        // 设置控制器作为textView的代理来监听textView文本的改变 - 让发送按钮可以点击
        textView.delegate = self

        
        return textView;
    }()
    
    /// 表情键盘控制器
    private lazy var emoticonVC: LKEmoticonViewController = {
        let controller = LKEmoticonViewController()
        
        // 设置textView
        controller.textView = self.textView
        
        return controller
    }()

    /// 显示微博剩余长度
    private lazy var lengthTipLabel: UILabel = {
        let label = UILabel(fonsize: 12, textColor: UIColor.lightGrayColor())
        
        // 设置默认的长度
        label.text = String(self.statusMaxLength)
        
        return label
    }()
    
    /// 照片选择器的控制器
    private lazy var photoSelectorVC: LKPhotoSelectorViewController = {
        let controller = LKPhotoSelectorViewController()
        
        // 让照片选择控制器被被人管理(大控制器 管理它)
        self.addChildViewController(controller)
        
        return controller
    }()

    
    
}

extension LKComposeViewController: UITextViewDelegate {
    //MARK: -textView文本改变的时候调用
    /// textView文本改变的时候调用
    func textViewDidChange(textView: UITextView) {
        // 当textView 有文本的时候,发送按钮可用,
        // 当textView 没有文本的时候,发送按钮不可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        // 拿到微博的长度
        let statusLength = textView.emoticonText().characters.count
        // 剩余长度
        let length = statusMaxLength - statusLength
        // 赋值Label
        lengthTipLabel.text = String(length)
        
        // 判断 length 大于等于0显示灰色, 小于0显示红色
        lengthTipLabel.textColor = length < 0 ? UIColor.redColor() : UIColor.lightGrayColor()
    }
}
