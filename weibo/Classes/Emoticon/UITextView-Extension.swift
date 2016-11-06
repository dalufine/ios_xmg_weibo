//
//  UITextView-Extension.swift
//  weibo
//
//  Created by dalu on 2016/11/6.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**  插入表情  **/
    func insertEmoticon(_ emoticon : Emoticon){
        if emoticon.isEmpty {
            return
        }
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        if emoticon.emojiCode != nil {
            //获取光标位置
            let textRange = selectedTextRange!
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        //
        let textRange = selectedRange
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        attrMStr.replaceCharacters(in: textRange, with: attrImageStr)
        attributedText = attrMStr
        //重置文字大小
        self.font = font
        //重置光标位置
        selectedRange = NSRange(location: textRange.location + 1, length: 0)
    }
    
    
    /**  获取表情字符串  **/
    func getEmoticonString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) {
            (dict, range, _) -> Void in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        return attrMStr.string
    }
}

