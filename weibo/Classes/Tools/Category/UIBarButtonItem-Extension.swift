//
//  UIBarButtonItem-Extension.swift
//  weibo
//
//  Created by dalu on 2016/10/14.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(imageName:String){
        self.init()
        
        let uiBtn  =  UIButton()
        uiBtn.setImage(UIImage(named:imageName), for: .normal)
        uiBtn.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        uiBtn.sizeToFit()
        
        self.customView = uiBtn
        //self.init(customView:uiBtn)
    }
}
