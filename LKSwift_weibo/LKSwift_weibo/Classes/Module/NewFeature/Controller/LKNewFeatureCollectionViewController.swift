//
//  LKNewFeatureCollectionViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/1.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
// 重用 标识符
private let reuseIdentifier = "Cell"

class LKNewFeatureCollectionViewController: UICollectionViewController {

    
    // MARK: 属性
    private let itemCount = 4
    
    /// layout  流水布局
    private var layout = UICollectionViewFlowLayout()
    /// collectionVIew 创建时 init必须不为nil，调用父类时 要真实的创建
    init() {
        // 调用的父类 要真实创建
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 需要改成 自定义cell
        self.collectionView!.registerClass(LKNewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
             prepareLayout()
        
           }

    // MARK: - 设置layout的参数
    private func prepareLayout() {
         layout.itemSize = UIScreen.mainScreen().bounds.size
           //间距不要
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        //  CollectionView  继承与  scrollVIew
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 分页
        collectionView?.pagingEnabled = true
        // 取消弹簧效果
        collectionView?.bounces = false

        
        
    }
    

    //MARK: - collectionView 代理方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         // 需要 as！ 强转有值 为自定义cell ， 从缓存中取 重用cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LKNewFeatureCell
    
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    // collectionView分页滚动完毕cell看不到的时候调用
    //MARK: - collectionView显示完毕cell 调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 拿到 正在显示的cell的indexPath索引
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
        //根据索引 获取collectionView正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! LKNewFeatureCell
        
        // 最后一页动画
        if showIndexPath.item == itemCount - 1 {
            // 开始按钮动画
            cell.startButtonAnimation()
        }
    }
}
