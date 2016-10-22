//
//  User.swift
//  weibo
//
//  Created by dalu on 2016/10/20.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class User: NSObject {
    var profile_image_url : String?
    var screen_name : String?
    var verified_type : Int = -1 
    var mbrank : Int = 0 
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
