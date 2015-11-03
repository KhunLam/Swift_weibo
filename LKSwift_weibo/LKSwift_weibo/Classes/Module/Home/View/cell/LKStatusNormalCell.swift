//
//  LKStatusNormalCell.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/11/3.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit

// cell的 配图约束 ———原创
class LKStatusNormalCell: LKStatusCell {
    override func prepareUI() {
        super.prepareUI()
        
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 0, height: 0), offset: CGPoint(x: 0, y: StatusCellMargin))
        
        // 获取配图的宽高约束
        pictureViewHeightCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewWidthCon = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
    }

}
