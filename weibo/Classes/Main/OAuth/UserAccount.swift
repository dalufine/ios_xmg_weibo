//
//  UserAccount.swift
//  weibo
//
//  Created by dalu on 2016/10/16.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {
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
    
    // MARK: - 归档&接档
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")

    }
}
