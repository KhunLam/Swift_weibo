//
//  LKEmoticonViewController.swift
//  表情键盘
//
//  Created by lamkhun on 15/11/6.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

class LKEmoticonViewController: UIViewController {

    // MARK: - 属性 
    //cell的ID
    private var collectionViewCellIdentifier = "collectionViewCellIdentifier"
    /// textView
    weak var textView: UITextView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor.redColor()
        
        prepareUI()
        
        //结果viewDidLoad view.frame:(0.0, 0.0, 414.0, 736.0)
//         print("viewDidLoad view.frame:\(view.frame)")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //结果viewWillAppear view.frame:(0.0, 0.0, 414.0, 736.0)
//        print("viewWillAppear view.frame:\(view.frame)")
    }
    // 使用控制器的view作为textView的自定义键盘,控制器view的大小在 viewDidAppear 方法里面才确定 ---- 可以重写流水布局方法 就不用设它的frame了  ---让它打横 显示
    //只有显示完毕 键盘的frame 才是正确地
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //结果viewDidAppear view.frame:(0.0, 0.0, 414.0, 226.0)
//        print("viewDidAppear view.frame:\(view.frame)")
    }

    
    
    // MARK: -准备UI
    private func prepareUI() {
       // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)

    
        
        
        // 添加约束
        // 手动添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        // VFL
        
        let views = ["cv" : collectionView, "tb" : toolBar]
        // collectionView水平方向
        let collectionViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        view.addConstraints(collectionViewH)
        // toolBar水平方向 -- 一步写
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        /// 设置toolBar
        setupToolBar()
        
        /// 设置collectioView
        setupCollectionView()
    }
    
    /// 按钮的起始tag
    private let baseTag = 1000
    
    /// 设置toolBar
    private func setupToolBar() {
        // 记录 item 的位置
        var index = 0
        
      
        
        // 数组 装载toolBar 的控件
        var items = [UIBarButtonItem]()
        //循环创建 toolBar的四个点击按钮
//        for name in ["最近", "默认", "emoji", "浪小花"] {
        for package in packages {
            let button = UIButton()
            let name = package.group_name_cn
            // 设置标题
            button.setTitle(name, forState: UIControlState.Normal)
            // 设置点击时颜色
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            //子适应按钮大小
            button.sizeToFit()
            
            // 让最近表情包高亮
            if index == 0 {
                switchSelectedButton(button)
            }

            // 设置tag, 加载基准的tag 1000
            button.tag = index + baseTag
            
            // 添加点击事件
            button.addTarget(self, action: "itemClick:", forControlEvents: UIControlEvents.TouchUpInside)

            // 创建 barbuttomitem
            let item = UIBarButtonItem(customView: button)
            
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
        }
        // 移除最后一个多有的弹簧
        items.removeLast()
        
        toolBar.items = items
        
        
    }
    
    
    // 处理toolBar点击事件
    func itemClick(button: UIButton) {
    
//       print("button.tag:\(button.tag)")
    
        // button.tag 是加上了基准tag的: 从1000 - 1003
        // scction 0 - 3
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        // 让collectionView滚动到对应位置
        // indexPath: 要显示的cell的indexPath
        // animated: 是否动画
        // scrollPosition: 滚动位置  --到最左边
//        print("滚动到section = \(indexPath.section)")
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        
        
        switchSelectedButton(button)
    }
    
    
    /// 记录当前选中高亮的按钮
    private var selectedButton: UIButton?
    
    /**
     使按钮高亮
     - parameter button: 要高亮的按钮
     */
    private func switchSelectedButton(button: UIButton) {
        // 取消之前选中的
        selectedButton?.selected = false
        
        // 让点击的按钮选中
        button.selected = true
        
        // 将点击的按钮赋值给选中的按钮
        selectedButton = button
    }

    
    
    /// 设置collectioView
    private func setupCollectionView() {
        // 设置背景颜色
        collectionView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        // 设置数据源代理
        collectionView.dataSource = self
        
        // 设置代理
        collectionView.delegate = self

        // 注册cell
        collectionView.registerClass(LKEmoticonCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
    
    }
    
  // MARK: -懒加载
    ///用 collectionView 显示表情 较好  通常用流水布局
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: LKCollectionViewFlowLayout())
    
    ///底部的 toolBar
    private lazy var toolBar = UIToolbar()
    
    /// 表情包模型 --所有
    /// 访问内存中的表情包模型数据
    private lazy var packages = LKEmoticonPackage.packages

}


// MARK: - 扩展 LKEmoticonViewController 实现 协议 UICollectionViewDataSource
  // 一定要实现方法 不然报错哦
extension LKEmoticonViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    // 返回多少组(一个表情包一组)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    // 返回cell(表情)的数量(每个表情包里面的表情数量不一样)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //测试  3列*7行 两页
//        return  21 * 2
        
        // 获取对应表情包里面的表情数量
        // packages[section]: 获取对应的表情包
        // packages[section].emoticons?.count 获取对应的表情包里面的表情数量
         return packages[section].emoticons?.count ?? 0
        
        
    }
    
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        // 强转cell 为自定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellIdentifier, forIndexPath: indexPath) as! LKEmoticonCell
        
//        cell.backgroundColor = UIColor.randomColor()
        
        // 获取对应的表情模型
//        packages[indexPath.section] 找到对应的表情包
//        packages[indexPath.section].emoticons?[indexPath.item] 找到对应的单个表情
        let emoticon = packages[indexPath.section].emoticons?[indexPath.item]
        
        // 赋值给cell
        cell.emoticon = emoticon
        
        return cell
        
    }
    // 监听scrollView滚动,当停下来的时候判断显示的是哪个section
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取到正在显示的section -> indexPath
        // 获取到collectionView正在显示的cell的IndexPath
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            // 获取对应的section 0 - 3
            let section = indexPath.section
//            print("停止滚动 section: \(section)")
            
            // section 和按钮的位置是对应的 一组
            // 获取toolBar上面的button
            // button.tag 是加上了基准tag的: 从1000 - 1003 baseTag = 1000  
            // 不加会崩 toolbar 强转为 button --- 不能为0开始时 随便加个数
            // section 0 - 3
            let button = toolBar.viewWithTag(section  + baseTag) as! UIButton
            
//            print("查找到的按钮的tag: \(button.tag)")
            // 让它选中
            switchSelectedButton(button)
        }
    }

    /*
    将点击的表情插入到textView里面
    1.获取textView
    2.需要知道点击哪个表情
    */
    //collectionView  cell 点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 添加表情到textView
        // 获取到表情
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
//                print("cell 点击, 表情: \(emoticon)")
   
//        insertEmoticon(emoticon)
        /// 添加表情到textView
        textView?.insertEmoticon(emoticon)
        
        // 当点击最近里面的表情,发现点击的和添加到textView上面的不是同一个,原因是数据发生改变,显示没有变化
        // 1.刷新数据
        // collectionView.reloadSections(NSIndexSet(index: indexPath.section))
        // 2.当点击的是最近表情包得表情,不添加到最近表情包和排序
        if indexPath.section != 0 {
            // 添加 表情模型 到  最近表情包
            LKEmoticonPackage.addFavorate(emoticon)
        }

    }
        /// 添加表情到textView
//    private func insertEmoticon(emoticon: LKEmoticon) {
//        // 获取 textView ----- 外界传入
//        guard let tv = textView else {
//            print("没有textView,无法添加表情")
//            return
//        }
//
//         添加emoji表情--系统自带
//        if let emoji = emoticon.emoji{
//            //插入文本
//            tv.insertText(emoji)
//        }
//        // 添加图片表情  --判断是否 有表情  --用文本附件的形式 显示表情
//        if let pngPath = emoticon.pngPath {
//            //一① 创建附件 --
//            let attachment = LKTextAttachment()
//            //② 创建 image
//            let image = UIImage(contentsOfFile: pngPath)
//            
//            //③ 将 image 添加到附件
//            attachment.image = image
//            
//            // 将表情图片的名称赋值  ---自定义属性 记录
//            attachment.name = emoticon.chs
//            
//            // 获取文本font的线高度  --文字高度
//            let height = tv.font?.lineHeight ?? 10
//            // 设置附件大小
//            attachment.bounds = CGRect(x: 0, y: -(height * 0.25), width: height, height: height)
//
//            //二① 创建属性文本 可变的
//        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
//            
//            // 发现在表情图片后面在添加表情会很小.原因是前面的这个表请缺少font属性
//            // 给属性文本(附件) 添加 font属性 --附件 Range 0开始 长度1
//            attrString.addAttribute(NSFontAttributeName, value: tv.font!, range: NSRange(location: 0, length: 1))
//            
//            // 获取到已有的文本,将表情添加到已有的可变文本后面
//        let oldAttrString = NSMutableAttributedString(attributedString: tv.attributedText)
//            
//            // 记录选中的范围
//            let oldSelectedRange = tv.selectedRange
//            // range: 替换的文本范围
//            oldAttrString.replaceCharactersInRange(oldSelectedRange, withAttributedString: attrString)
//            
//            //三① 赋值给textView的 attributedText 显示
//            tv.attributedText = oldAttrString
//            
//            
//            //② 设置输入光标位置,在表情后面
//            tv.selectedRange = NSRange(location: oldSelectedRange.location + 1, length: 0)
//
//        }
//    }
    
    
}


// MARK: - 自定义表情cell
class LKEmoticonCell: UICollectionViewCell {
   
    // MARK: - 属性
    /// 表情模型
    var emoticon: LKEmoticon?{
        didSet{
            // 设置内容
            // 设置图片
//             print("emoticon.png:\(emoticon?.pngPath)")
            // 若果有值 才设置
            if let pngPath = emoticon?.pngPath {
                emoticonButton.setImage(UIImage(contentsOfFile: pngPath), forState: UIControlState.Normal)
            } else {    // 防止cell复用（空地址时就不显示）
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            // 显示emoji表情 （有值才设）
            //            if let emoji = emoticon?.emoji {
            //                emoticonButton.setTitle(emoji, forState: UIControlState.Normal)
            //            } else {
            //                emoticonButton.setTitle(nil, forState: UIControlState.Normal)
            //            }
            //  ？可有值 可nil 自行判断
            emoticonButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            // 判断是否是删除按钮模型 --true 要创建
            if emoticon!.removeEmoticon {
                // 是删除按钮
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }

        }
    }
    
    // MARK: -构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print("frame:\(frame)")
        
        prepareUI()
    }
    
    // MARK: -准备UI
    private func prepareUI() {
    
         // 添加子控件
        contentView.addSubview(emoticonButton)
        // 设置表情 frame  内间距 四边都有4 的间距  一定要用bounds 
        emoticonButton.frame = CGRectInset(bounds, 4, 4)
        // 设置title大小 （让表情的大小 一致）
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)

        // 禁止按钮可以点击 -- 为了让CollectionView响应
        emoticonButton.userInteractionEnabled = false
        
        //emoticonButton.backgroundColor = UIColor.magentaColor()
    }

    // MARK: -懒加载
    /// 表情按钮 (可点击 用按钮)
     private lazy var emoticonButton: UIButton = UIButton()
}




// MARK: - 继承流水布局
// 布局之前 就重写 第一次布局调用的是 prepareLayout（）
// 可以 重写流水布局方法 ---让它打横 显示 // 重写 prepareLayout 必须调用父类的
/// 在collectionView布局之前设置layout的参数
class LKCollectionViewFlowLayout: UICollectionViewFlowLayout {
    // 重写 prepareLayout
    override func prepareLayout() {
        super.prepareLayout()
        // 布局所在的collectionView  --结果frame = (0 0; 414 182) 就是表情显示的frame 182 + 44 = 226键盘高度
//        print("collectionView:\(collectionView)")
        
        // item 宽度
        let width = collectionView!.frame.width / 7.0
        
        // item 高度
        let height = collectionView!.frame.height / 3.0
        
        // 设置父类 layout 的 itemSize
        itemSize = CGSize(width: width, height: height)

        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        // 取消弹簧效果
        collectionView?.bounces = false
        collectionView?.alwaysBounceHorizontal = false
        
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 分页显示
        collectionView?.pagingEnabled = true
        
    }



}







