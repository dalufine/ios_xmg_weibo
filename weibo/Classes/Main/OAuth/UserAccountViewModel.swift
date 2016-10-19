//
//  UserAccountTool.swift
//  weibo
//
//  Created by dalu on 2016/10/17.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    var account : UserAccount?
    
    // MARK: - 计算属性
    var accountPath : String{
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin : Bool{
        if(account == nil){
            return false
        }
        guard let expires_date = account?.expires_date else{
            return false
        }
        return  (expires_date.compare(Date()) == ComparisonResult.orderedDescending)
    }
    
    // MARK: - init
    init(){
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
}
