//
//  StatusViewModel.swift
//  weibo
//
//  Created by dalu on 2016/10/21.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    var status : Status?
    
    //来源
    var sourceText : String?
    var createAtText : String?
    
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    var profile_url : URL?
    
    
    init(status : Status) {
        self.status = status
        
        if let source = status.source , source != "" {
            let startIndex = (source as NSString).range(of: ">").location+1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        if let created_at = status.created_at {
            createAtText = TimeTools.formatCreateTime(created_at: created_at)
        }
        
        let verified_type = status.user?.verified_type ?? -1
        
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        let profileStr = status.user?.profile_image_url ?? ""
        profile_url = URL(string: profileStr)
        
        
        
    }
    
}
