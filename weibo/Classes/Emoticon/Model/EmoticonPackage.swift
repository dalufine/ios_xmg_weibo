//
//  EmoticonPackage.swift
//  weibo
//
//  Created by dalu on 2016/11/5.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    
    
    init(_ id : String){
        super.init()
        //zuijin
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        let pListPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        guard let array = NSArray(contentsOfFile: pListPath) else {
            return
        }
        let arr = array as! [[String : String]]
        
        var index = 0
        for var dict in arr {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index = index + 1
            
            if index == 20 {
                emoticons.append(Emoticon(isRemove : true))
                index = 0
            }
        }
        addEmptyEmoticon(isRecently: false)
    }
    
    func addEmptyEmoticon(isRecently : Bool){
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty : true))
        }
        emoticons.append(Emoticon(isRemove : true))
    }
}
