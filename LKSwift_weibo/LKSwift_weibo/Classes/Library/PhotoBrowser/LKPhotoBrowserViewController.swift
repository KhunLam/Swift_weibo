//
//  LKPhotoBrowserViewController.swift
//  照片浏览器
//
//  Created by lamkhun on 15/11/9.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SVProgressHUD

//照片浏览器-需求分析-->UIViewController-->collectionView -->collectionViewCell --->scrollView --> imageView
///cell间距
let LKPhotoBrowserMinimumLineSpacing: CGFloat = 10

class LKPhotoBrowserViewController: UIViewController {

    
    // MARK: - 属性
    /// cell重用id
    private let cellIdentifier = "cellIdentifier"
    
    /// 大图的urls
//    private var urls: [NSURL]
    
    private var selectedIndex: Int
    /// 图片模型
    private var photoModels: [LKPhotoBrowserModel]
    
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()

    // MARK: - 构造函数
    init(models: [LKPhotoBrowserModel], selectedIndex: Int) {
//        self.urls = urls
        self.photoModels = models
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
    
          prepareUI()
        
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"
    }

    
    // 显示点击对应的大图  -- 不要动画
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 滚动到对应的张数 selectedIndex-> IndexPath
        let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        
        // 滚动到对应的张数 UICollectionViewScrollPosition.Left
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
    }

    
    private func prepareUI() {
        // 添加子控件 --顺序不要搞错
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        view.addSubview(pageLabel)
        
        // 按钮添加点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "cv": collectionView,
            "cb": closeButton,
            "sb": saveButton,
            "pl": pageLabel
        ]
        // collectionView, 填充父控件 --有间距

        // 将colllectionView的宽度+间距
        collectionView.frame =  CGRect(x: 0, y: 0, width: UIScreen.width() + LKPhotoBrowserMinimumLineSpacing, height: UIScreen.height())
//  view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 页码
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        
        // 关闭、保存按钮
        // 高度35距离父控件底部8
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cb(75)]-(>=0)-[sb(75)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))


        // 设置collectionView
        prepareCollectionView()
    }
    
    //MARK: -设置collectionView
    private func prepareCollectionView() {
        // 注册cell
        collectionView.registerClass(LKPhotoBrowserCell.self, forCellWithReuseIdentifier: cellIdentifier)
      
        // layout.item
        layout.itemSize = view.bounds.size
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 让cell 偏移间距 使最后一张图显示 完整
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: LKPhotoBrowserMinimumLineSpacing)
        
        // 间距设置为0
        layout.minimumInteritemSpacing = LKPhotoBrowserMinimumLineSpacing
        layout.minimumLineSpacing = LKPhotoBrowserMinimumLineSpacing
        
        // 不需要弹簧效果
        collectionView.bounces = false
        
        // 分页显示
        collectionView.pagingEnabled = true
        
        // 数据源和代理
        collectionView.dataSource = self
        collectionView.delegate = self

    
    }
    
    // MARK: -按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
//        print(__FUNCTION__)
    }
    
    func save() {
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 获取正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LKPhotoBrowserCell
        
        // 获取正在显示的图片
        if let image = cell.imageView.image {
            // 保存图片
            
            // completionTarget: 保存成功或失败,回调这个对象
            // completionSelector: 回调的方法 文档要求 要写成下面的格式 就能保存
            // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
            // image didFinishSavingWithError contextInfo : 前面的名称 都相当于swift里面的外部参数名  void *任意类
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }

    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            // 保存失败
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
         SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
        
    }
    
    
    // MARK: -懒加载
    /// collectionView
     lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// 关闭
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 保存
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.whiteColor(), fontSzie: 12)

    /// 页码的label
    private lazy var pageLabel = UILabel(fonsize: 15, textColor: UIColor.whiteColor())
    
}


// MARK: - 扩展 CZPhotoBrowserViewController 实现 UICollectionViewDataSource 和 UICollectionViewDelegate
extension LKPhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
    // 返回cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! LKPhotoBrowserCell
        
//        cell.backgroundColor = UIColor.randomColor()
        cell.backgroundColor = UIColor.blackColor()
        
        // 设置cell要显示的url
//        cell.url = urls[indexPath.item]
        cell.url = photoModels[indexPath.item].url
        return cell
    }
    
    // scrolView停止滚动,获取当前显示cell的indexPath
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 赋值 selectedIndex,
        selectedIndex = indexPath.item
        
        // 设置页数
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"
    }
}



// MARK: - 转场动画

///转场动画代理  实现 动画的样式
extension LKPhotoBrowserViewController: UIViewControllerTransitioningDelegate {
    
    // 返回 控制 modal动画 对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 创建 控制 modal动画 对象
        return LKPhotoBrowserModalAnimation()
    }
    
    // 控制 dismiss动画 对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LKPhotoBrowserDismissAnimation()
    }
    
    
    
}

// MARK: -扩展 转场动画
extension LKPhotoBrowserViewController {
// 提供转场动画的过渡视图, 需要知道显示的图片,还需要知道点击的cell的frame
    // 最好 知道 该图片的 所有信息 ---- 弄一个图片 模型

// MARK: - modal动画相关
    /**
    返回modal出来时需要的过渡视图
    - returns: modal出来时需要的过渡视图
    */
    func modalTempImageView() -> UIImageView {
    
        // 缩略图的view  模型中取
        let thumbImageView = photoModels[selectedIndex].imageView!
        
        // 创建过渡视图
        let tempImageView = UIImageView(image: thumbImageView.image)

        // 设置参数 -- 模式与 剪图
        tempImageView.contentMode = thumbImageView.contentMode
        tempImageView.clipsToBounds = true
      
        
        // 设置过渡视图的frame
        // 直接设置是不行的,坐标系不一样
        // tempImageView.frame = thumbImageView.frame
        
        // thumbImageView.superview!: 转换前的坐标系
        // rect: 需要转换的frame
        // toCoordinateSpace: 转换后的坐标系
        let rect = thumbImageView.superview!.convertRect(thumbImageView.frame, toCoordinateSpace: view)
        
        // 设置转换好的frame
        tempImageView.frame = rect
        
        return tempImageView
        
    }
    /**
     返回 modal动画时放大的frame
     - returns: modal动画时放大的frame
     */
    func modalTargetFrame() -> CGRect {
        // 获取到对应的缩略图
        let thumbImageView = photoModels[selectedIndex].imageView!
        
        // 获取缩略图
        let thumbImage = thumbImageView.image!
        
        // 计算宽高
        let newSize = thumbImage.displaySize()
        
        // 判断长短图
        var offestY: CGFloat = 0
        if newSize.height < UIScreen.height() {
            //短图
            offestY = (UIScreen.height() - newSize.height) * 0.5
        }
        
        return CGRect(x: 0, y: offestY, width: newSize.width, height: newSize.height)
    }
    
    // MARK: - dismiss动画相关
    /**
    返回dismiss时的过渡视图
    - returns: dismiss时的过渡视图
    */
    func dismissTempImageView() -> UIImageView {
        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LKPhotoBrowserCell
        
        // 获取正在显示的图片
        let image = cell.imageView.image!
        
        // 创建过渡视图
        let tempImageView = UIImageView(image: image)
        
        // 设置过渡视图 属性 
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
        tempImageView.clipsToBounds = true
        
        // 设置frame
        // 转换坐标系
        let rect = cell.imageView.superview!.convertRect(cell.imageView.frame, toCoordinateSpace: view)
        tempImageView.frame = rect
        
        return tempImageView
    }
    
    /**
     返回缩小后的fram
     - returns: 缩小后的fram
     */
    func dismissTargetFrame() -> CGRect {
        let model = photoModels[selectedIndex]
        let thumbImageView = model.imageView
        
        // 坐标系转换
        let rect = model.imageView!.superview!.convertRect(model.imageView!.frame, toCoordinateSpace: view)
        
        return rect
    }

}

