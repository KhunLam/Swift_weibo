//
//  LKStatusPictureView.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
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
        if count == 1 {
            let size = CGSize(width: 150, height: 120)
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


// MARK: - 扩展 CZStatusPictureView 类,实现 UICollectionViewDataSource协议
extension LKStatusPictureView: UICollectionViewDataSource {
 
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

}

// MARK: - 自定义cell  显示图片
// 自定义cell  显示图片
class LKStatusPictureViewCell: UICollectionViewCell {

    // MARK: - 属性
    var imageURL: NSURL? {
        didSet {
            // 设置图片 下载
            iconView.lk_setImageWithURL(imageURL)
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
        
        // 添加约束
        // 填充父控件
        iconView.ff_Fill(contentView)
    }

    
    // MARK: -懒加载
    /// 图片
    private lazy var iconView = UIImageView()
}
