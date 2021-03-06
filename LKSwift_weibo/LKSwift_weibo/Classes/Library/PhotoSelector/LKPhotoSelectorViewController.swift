//
//  LKPhotoSelectorViewController.swift
//  照片选择器
//
//  Created by lamkhun on 15/11/8.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LKPhotoSelectorViewController: UICollectionViewController,LKPhotoSelectorCellDelegate {
    
    // MRAK: - 属性
    /// 选择的图片 数组
    var photos = [UIImage]()
    
    /// 记录点击的cell indexPath
    var currentIndexPath: NSIndexPath?
    
    /// 最大照片张数
    private let maxPhotoCount = 9
    
    /// collectionView 的 布局
    private var layout = UICollectionViewFlowLayout()
    
    
    // MRAK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCollectionView()
        
    }
    /// 准备CollectionView
    func prepareCollectionView() {
       
        collectionView?.backgroundColor = UIColor.whiteColor()
        // 设置layout 参数
        // 设置itemSize
        layout.itemSize = CGSize(width: 80, height: 80)
        
        // layout设置section间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        
        // 注册cell
        collectionView?.registerClass(LKPhotoSelectorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    
    }

   
    // MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 9
        // 当图片数量小于最大张数, cell的数量 = 照片的张数 + 1
        // 当图片数量等于最大张数, cell的数量 = 照片的张数
        return photos.count < maxPhotoCount ? photos.count + 1 : photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!LKPhotoSelectorCell
    
        cell.backgroundColor =  UIColor.brownColor()
        //设置代理
        cell.cellDelegate = self
        
        /*
        照片的数量   cell的数量     indexPath
        0           1           0
        1           2           0,1
        2,          3           0,1,2
        */
        // 当有图片的时候才设置图片  防止越界
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.item]
        } else {    //当没有图片的时候 设加号 设置图片防止cell复用
            cell.setAddButton()
        }

        
        return cell
    }
    //MARK: - cell代理方法--添加图片--删除图片
    /// 添加图片
    func photoSelectorCellAddPhoto(cell: LKPhotoSelectorCell) {
//       print(__FUNCTION__)
//        print("cell\(cell)")
    
        // 判断相册是否可用
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("相册不可用")
            return
        }
        
        // 得到系统的相册
        let picker = UIImagePickerController()
        // 设置相册代理
        picker.delegate = self
        
        // 记录当前点击的cell的indexPath --用来判断是否点击的是加号按钮
        currentIndexPath = collectionView?.indexPathForCell(cell)
        
        // Model进系统的相册
        presentViewController(picker, animated: true, completion: nil)
    }
    
    /// 删除图片
    func photoSelectorCellRemovePhoto(cell: LKPhotoSelectorCell) {
//       print(__FUNCTION__)
//     print("cell\(cell)")
        
        // 点击的是哪个cell的删除按钮
        let indexPath = collectionView!.indexPathForCell(cell)!
        
        // 删除photos对应的图片
        photos.removeAtIndex(indexPath.item)

        // 当图片cell 少于最大值-1 时 才能刷新某一行
        //因为 deleteItemsAtIndexPaths cell需要少一个 （而实质remove没有了）
        if photos.count < maxPhotoCount-1 {
            //刷新collectionView,某一行
            collectionView?.deleteItemsAtIndexPaths([indexPath])
        } else {
            // 刷新全部
            collectionView?.reloadData()
        }

        
    }

}
//MARK: -------------------相册代理-------------------
extension LKPhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 选择照片时的代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        print("image:\(image)")
        // 当图片比较大的时候将它图片缩小
        let newImage = image.scaleImage()
//        print("newImage:\(newImage)")
        
        // 将选择的照片添加到数组,让collectionView去显示
        // 如果点击的是图片,就是替换图片,如果点击的是加号按钮,添加图片
        // 点击cell的item 小于图片数组的花 就是点击了图片
        if currentIndexPath?.item < photos.count {
            // 点击的是图片,替换原来图片
            photos[currentIndexPath!.item] = newImage
        } else {
            // 点击的是加号按钮 添加
            photos.append(newImage)
        }

        // 刷新数据
        collectionView?.reloadData()
        
        // 关闭系统的相册
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


//MARK: - ---------------自定义cell----------------
// MARK: cell点击时间代理
@objc protocol LKPhotoSelectorCellDelegate: NSObjectProtocol {
    // 点击加号代理方法
    func photoSelectorCellAddPhoto(cell: LKPhotoSelectorCell)
    
    // 点击删除代理方法
    func photoSelectorCellRemovePhoto(cell: LKPhotoSelectorCell)
    
    // 可选的方法 协议需要加 @objc
//    optional
//    func test()
}



//MARK: 自定义cell
class LKPhotoSelectorCell: UICollectionViewCell {

    //MARK: - Getting&Setting 属性
    // image 用来显示, 替换加号按钮的图片
    var image: UIImage? {
        didSet {
            addButton.setImage(image, forState: UIControlState.Normal)
            addButton.setImage(image, forState: UIControlState.Highlighted)
            
            //有图时 显示删除按钮
            removeButton.hidden = false
        }
    }
    
    /// 设置加号按钮的图片
    func setAddButton() {
        // 设置按钮图片
        addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        addButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        
        //只是加号时 隐藏删除按钮
        removeButton.hidden = true
    }

    
    // MARK: - 属性
    weak var cellDelegate: LKPhotoSelectorCellDelegate?
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["ab": addButton, "rb": removeButton]
        // 添加约束
        // 加号按钮
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 删除按钮
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[rb]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }


    


    // MARK: - 按钮点击事件 -设代理
    func addPhoto() {
//        print("addPhoto")
        cellDelegate?.photoSelectorCellAddPhoto(self)
    }
    
    func removePhoto() {
//        print("removePhoto")
        cellDelegate?.photoSelectorCellRemovePhoto(self)
        
        //  cellDelegate?.test?()
    }


    // MARK: - 懒加载
    /// 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮图片
        button.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置按钮图片的显示模式 -等比例
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        // 添加点击事件
        button.addTarget(self, action: "addPhoto", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    /// 删除按钮
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        
        // 添加点击事件
        button.addTarget(self, action: "removePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()



}

