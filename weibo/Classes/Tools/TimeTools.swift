//
//  TimeTools.swift
//  weibo
//
//  Created by dalu on 2016/10/20.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class TimeTools: NSObject {
    
    //func关键字之前加上关键字static或者class都可以用于指定类方法
    //class关键字指定的类方法可以被子类重写
    class func formatCreateTime(created_at : String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        guard let createDate = fmt.date(from: created_at) else {
            return ""
        }
        
        let nowDate = Date()
        
        //计算时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        if interval < 60 {
            return "刚刚"
        }
        if interval < 60*60 {
            return "\(interval / 60)分钟前"
        }
        if interval < 60*60*24 {
            return "\(interval/60/60)小时前"
        }
        
        let cuurentC = Calendar.current
        
        if cuurentC.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            return fmt.string(from: createDate)
        }
        
        if cuurentC.component(.year, from: createDate)<1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.string(from: createDate)
        }
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.string(from: createDate)
        
    }
}
