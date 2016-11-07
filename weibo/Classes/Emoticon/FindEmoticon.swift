//
//  FindEmoticon.swift
//  weibo
//
//  Created by dalu on 2016/11/7.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    lazy var manager = EmoticonManager()
    //
    static let shareInstance = FindEmoticon()
    //
    func findAttrString(statusText : String?, font : UIFont) -> NSAttributedString? {
        guard let statusText = statusText else {
            return nil
        }
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: (statusText as NSString).length))
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        //必须倒序去取
        for (_, result) in results.enumerated().reversed() {
            let chs = (statusText as NSString).substring(with: result.range)
            let attachment = NSTextAttachment()
            guard let pngPath = findPngPath(chs) else {
                continue
            }
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        //
        return attrMStr
    }
    
    private func findPngPath(_ chs : String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
