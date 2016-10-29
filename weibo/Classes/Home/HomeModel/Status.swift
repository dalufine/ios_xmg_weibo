//
//  Status.swift
//  weibo
//
//  Created by dalu on 2016/10/19.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class Status: NSObject {
    var created_at : String? 
    var source : String? 
    var text : String?
    var mid : Int = 0
    var user : User?
    var pic_urls :[[String:String]]?
    var retweeted_status : Status?  //转发
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String : Any]{
            user = User(dict: userDict)
        }
        
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : Any]{
            retweeted_status = Status(dict: retweetedStatusDict);
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
