//
//  LKStatusPictureView.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SDWebImage

// 在类外面全局的,任何地方都可以访问
/// 点击cell通知的名称
let LKStatusPictureViewCellSelectedPictureNotification = "LKStatusPictureViewCellSelectedPictureNotification"
/// 图片地址
let LKStatusPictureViewCellSelectedPictureURLKey = "LKStatusPictureViewCellSelectedPictureURLKey"
/// 对应的cell
let LKStatusPictureViewCellSelectedPictureIndexKey = "LKStatusPictureViewCellSelectedPictureIndexKey"
/// 图片模型
let LKStatusPictureViewCellSelectedPictureModelKey = "LKStatusPictureViewCellSelectedPictureModelKey"

// 图片显示collectionView
class LKStatusPictureView: UICollectionView {
   // MARK: - 属性
    /// cell重用表示
    private let StatusPictureViewIdentifier = "StatusPictureViewIdentifier"

    
    /// 布局
    private var layout = UICollectionViewFlowLayout()
    /// 微博模型
    var statusPicture: LKStatus?{
        didSet{
//            sizeToFit()
//            print("frame\(frame)")
            reloadData()
        }
    }
    // 这个方法是 sizeToFit调用的,而且 返回的 CGSize 系统会设置为当前view的size
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        
        // 设置数据源
        dataSource = self
 
        // 设置代理
        delegate = self
        
        // 设置背景
        backgroundColor = UIColor.clearColor()
//
//        // 注册cell  LKStatusPictureViewCell
        registerClass(LKStatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureViewIdentifier)
    }
    
    /// 根据微博模型,计算配图的尺寸
    func calcViewSize() -> CGSize {
        // itemSize
        let itemSize = CGSize(width: 90, height: 90)
        
        // 设置itemSize
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 间距
        let margin: CGFloat = 6
        
        // 列数
        let column = 3
        
        // 根据模型的图片数量来计算尺寸
        let count = statusPicture?.pictureURLs?.count ?? 0
        
        // 没有图片
        if count == 0 {
            return CGSizeZero
        }
        // 在这个时候需要有图片,才能获取到图片的大小,缓存图片越早越好
        if count == 1 {
            // 获取图片的url路径
            let urlString = statusPicture!.pictureURLs![0].absoluteString
            // 获取缓存好的图片,缓存的图片可能没有成功
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            var size = CGSize(width: 150, height: 120)
            
            // 当有图片的时候在来赋值
            if image != nil {
                size = image.size
            }
            
            
            // 如果图片宽度太小
            if size.width < 40 {
                size.width = 40
            }

            
            layout.itemSize = size
            return size
        }
        
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        // 4 张图片
        if count == 4 {
            let width = 2 * itemSize.width + margin
            return CGSize(width: width, height: width)
        }

        // 剩下 2, 3, 5, 6, 7, 8, 9
        // 计算行数: 公式: 行数 = (图片数量 + 列数 -1) / 列数
        let row = (count + column - 1) / column
        
        // 宽度公式: 宽度 = (列数 * item的宽度) + (列数 - 1) * 间距
        let widht = (CGFloat(column) * itemSize.width) + (CGFloat(column) - 1) * margin
        
        // 高度公式: 高度 = (行数 * item的高度) + (行数 - 1) * 间距
        let height = (CGFloat(row) * itemSize.height) + (CGFloat(row) - 1) * margin
        
        return CGSize(width: widht, height: height)

    }

    
}


// MARK: - 扩展 CZStatusPictureView 类,实现 UICollectionViewDataSource,Delegate协议
extension LKStatusPictureView: UICollectionViewDataSource,UICollectionViewDelegate {
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusPicture?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StatusPictureViewIdentifier, forIndexPath: indexPath) as!LKStatusPictureViewCell
        
//                cell.backgroundColor = UIColor.randomColor()
        
//        let url = statusPicture?.pic_urls?[indexPath.item]["thumbnail_pic"] as? String
//        cell.imageURL = NSURL(string: url!)
         cell.imageURL = statusPicture?.pictureURLs?[indexPath.item]
        return cell
    }
    
    
    // cell点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 点击cell 获得对应的图片地址
//        print("缩略图url地址:\(statusPicture?.storePictureURLs)")
//        print("大图url地址:\(statusPicture?.largePictureURLs)")
        
        // 点击的哪个cell -----  // indexPath.item
        // 点击某个cell 通知首页的控制器  弹出查看大图控制器 （多层嵌套）
        // 图片cell（collectionViewCell） --> collectionView (statusCell微博cell) -->首页的控制器
        // 代理,闭包,通知
        /*
        闭包:1嵌套层次不是很深  2可以有返回值
        代理:
        1. 1对1 (xmpp的可以一对多)
        2. 嵌套层次不是很深
        3. 代理可以有返回值
        通知:
        1. 1对多
        2. 嵌套层次无所谓
        3. 无法获取返回值
        */
        
        //cell点击了 提供模型给图片模型
        // 提供 图片可变模型
        var models = [LKPhotoBrowserModel]()
        // 大图URL的数量
        let count = statusPicture?.largePictureURLs?.count ?? 0
        
        // 遍历 每一张图 创建一个模型
        for i in 0..<count {
            // 创建模型
            let model = LKPhotoBrowserModel()
            // 对应 图片的大图URL
            let url = statusPicture?.largePictureURLs?[i]
            
            // 缩略图的Imageview
            // 根据索引拿到cell  ,collectionView 通过 Item
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! LKStatusPictureViewCell
            let imageView = cell.iconView
            
            model.url = url
            model.imageView = imageView
            
            models.append(model)
        }

        /**
         *  Name:通知名 ，object：谁发送的 ，userInfo：附加信息
         */
         // 发送通知,携带 url 点击的 cell的Index
         // 发送通知,附加信息携带 url 点击的 cell的Index
         // 想把 url 和 点击的indexPath.item传给控制器
        let userInfo: [String: AnyObject] = [
            LKStatusPictureViewCellSelectedPictureModelKey: models,
            LKStatusPictureViewCellSelectedPictureURLKey: statusPicture!.largePictureURLs!,
            LKStatusPictureViewCellSelectedPictureIndexKey: indexPath.item
        ]
        // 创建通知
        NSNotificationCenter.defaultCenter().postNotificationName(LKStatusPictureViewCellSelectedPictureNotification, object: self, userInfo: userInfo)
        

        
    }

}

// MARK: - 自定义cell  显示图片
// 自定义cell  显示图片
class LKStatusPictureViewCell: UICollectionViewCell {

    // MARK: - 属性
    var imageURL: NSURL? {
        didSet {
            // 设置图片 下载
            iconView.lk_setImageWithURL(imageURL)
            
            // 判断是否是gif图片 不是就隐藏gif小图标
            let gif = (imageURL!.absoluteString as NSString).pathExtension.lowercaseString == "gif"
            
            gifImageView.hidden = !gif
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        prepareUI()
    }


    // MARK: -准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(iconView)
        //gif图片
         contentView.addSubview(gifImageView)
        
        // 添加约束
        // 填充父控件
        iconView.ff_Fill(contentView)
        
        gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: contentView, size: nil)

    }

    
    // MARK: -懒加载
    /// 图片
    private lazy var iconView : UIImageView = {
        let imageView = UIImageView()
        
        // 设置内容模式
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    /// gif标示
    private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
}
