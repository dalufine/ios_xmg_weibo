//
//  UserAccount.swift
//  weibo
//
//  Created by dalu on 2016/10/16.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    var access_token : String?
    var expires_in : TimeInterval = 0.0 {
        // 监听
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var uid : String?
    var expires_date : Date?
    
    
    var screen_name : String?
    var avatar_large : String?
    
    init(dict :[String : Any]){
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String {
        //return "access_token:\(access_token),uid:\(uid)"
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
}
