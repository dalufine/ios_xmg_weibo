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
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        
        guard let userDict = dict["user"] as? [String : Any] else{
            return
        }
        user = User(dict: userDict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
