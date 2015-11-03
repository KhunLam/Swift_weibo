//
//  LKStatusTopView.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

//头部用户信息 View
class LKStatusTopView: UIView {

    // MARK: - 微博模型
    var statusUser: LKStatus? {
        didSet {
            // 用户头像
            if let iconUrl = statusUser?.user?.profile_image_url {
                iconView.lk_setImageWithURL(NSURL(string: iconUrl))
            }
            
            // 名称
            nameLabel.text = statusUser?.user?.name
            
            // 时间
            timeLabel.text = statusUser?.created_at
            
            // 来源
//            sourceLabel.text = "来自 \(status?.source) 微博"
            sourceLabel.text = "来自 ** 微博"
            // 认证类型
            // 判断类型设置不同的图片
            // 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
            verifiedView.image = statusUser?.user?.verifiedTypeImage
            
            // 会员等级
            memberView.image = statusUser?.user?.mbrankImage
        
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.redColor()
        prepareUI()
    }
    
    // MARK: - 准备UI
       func prepareUI() {
        // 添加子控件
        addSubview(topSeparatorView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(verifiedView)
        addSubview(memberView)
        
        // 添加约束
        /// 头像视图
        // 添加约束
        topSeparatorView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 10))
         iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topSeparatorView, size: CGSize(width: 35, height: 35), offset: CGPoint(x: StatusCellMargin, y: StatusCellMargin))

        
        /// 名称
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: StatusCellMargin, y: 0))
        
        /// 时间
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: StatusCellMargin, y: 0))
        
        /// 来源
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: StatusCellMargin, y: 0))
        
        /// 会员等级
        memberView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: StatusCellMargin, y: 0))
        
        /// 认证图标
        verifiedView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset: CGPoint(x: 8.5, y: 8.5))
    }

    
    
    // MARK: - 懒加载
    /// 顶部分割视图
    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        
        // 背景
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return view
    }()

    
    /// 用户头像
    private lazy var iconView = UIImageView()
    
    /// 用户名称
    private lazy var nameLabel: UILabel = UILabel(fonsize: 14, textColor: UIColor.darkGrayColor())
    
    /// 时间label
    private lazy var timeLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.orangeColor())
    
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.lightGrayColor())
    
    /// 认证图标
    private lazy var verifiedView = UIImageView()
    
    /// 会员等级
    private lazy var memberView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))


}
