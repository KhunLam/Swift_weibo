//
//  UITextView+Emoticon.swift
//  表情键盘
//
//  Created by lamkhun on 15/11/8.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
/// 扩展 UITextView 分类 
extension UITextView {
    
    /**
     获取带表情图片的字符串
     - returns: 带表情图片的字符串
     */
    func emoticonText() -> String {
    
        // 将所有遍历的文本拼接起来
        var text = ""
        
        // enumerationRange: 遍历的范围  --0开始 文本长度
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length:attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
//            print("dict\(dict)")  ///---打印驱动 key -- “NSAttachment”
//            print("range\(range)")
            // 如果dict有 "NSAttachment" key 并且拿出来有值(NSTextAttachment) 表情图片, 没有就是普通的文本NSFont
            if let attachment = dict["NSAttachment"] as? LKTextAttachment {
                
                // 需要获取到表情图片对应的名称
                // 需要一个属性记录下表情图片的名称,现有的类不能满足要求,创建一个类继承NSTextAttachment 的自定义类
                text += attachment.name!
                
            }else {
                // 普通文本,截取
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                text += str
            }
        }
        // 遍历完后输出
        return text
    }
   
    /**
     添加表情到textView
     - parameter emoticon: 要添加的表情
     */
       func insertEmoticon(emoticon: LKEmoticon) {
 
        // 判断如果是删除按钮
        if emoticon.removeEmoticon {
            // 删除文字或表情
            deleteBackward()
        }
        
        //         添加emoji表情--系统自带
        if let emoji = emoticon.emoji{
            //插入文本
            insertText(emoji)
        }
        // 添加图片表情  --判断是否 有表情  --用文本附件的形式 显示表情
        if let pngPath = emoticon.pngPath {
            //一① 创建附件 --
            let attachment = LKTextAttachment()
            //② 创建 image
            let image = UIImage(contentsOfFile: pngPath)
            
            //③ 将 image 添加到附件
            attachment.image = image
            
            // 将表情图片的名称赋值  ---自定义属性 记录
            attachment.name = emoticon.chs
            
            // 获取文本font的线高度  --文字高度
            let height = font?.lineHeight ?? 10
            // 设置附件大小
            attachment.bounds = CGRect(x: 0, y: -(height * 0.25), width: height, height: height)
            
            //二① 创建属性文本 可变的
            let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            // 发现在表情图片后面在添加表情会很小.原因是前面的这个表请缺少font属性
            // 给属性文本(附件) 添加 font属性 --附件 Range 0开始 长度1
            attrString.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))
            
            // 获取到已有的文本,将表情添加到已有的可变文本后面
            let oldAttrString = NSMutableAttributedString(attributedString: attributedText)
            
            // 记录选中的范围
            let oldSelectedRange = selectedRange
            // range: 替换的文本范围
            oldAttrString.replaceCharactersInRange(oldSelectedRange, withAttributedString: attrString)
            
            //三① 赋值给textView的 attributedText 显示
            attributedText = oldAttrString
            
            
            //② 设置输入光标位置,在表情后面
            selectedRange = NSRange(location: oldSelectedRange.location + 1, length: 0)
            
          
            // 让表情图片 也能 发出 extViewDidChange 给条用者 知道
            // 重新设置textView的attributedText没有触发textDidChanged
            // 主动调用代理的textViewDidChange
            delegate?.textViewDidChange?(self)
            
            // 主动发送 UITextViewTextDidChangeNotification
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)

        }
        
        
    }

    
    
    
}