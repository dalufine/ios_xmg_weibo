//
//  UIButton-Extension.swift
//  weibo
//
//  Created by dalu on 2016/10/14.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

extension UIButton{

    ///类方法
    class func createButton(imageName:String,bgImageName:String)->UIButton{
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named:bgImageName+"_highlighted"), for: .highlighted)
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
    
    ///构造方法,convenience修饰的构造函数是便利构造函数，其常用于对系统类进行构造函数扩充的时候使用
    ///特点：便利构造函数通常都是写在extension中，需要明确的调用self.init()不是super
    
    convenience init(imageName:String,bgImageName:String){
        self.init()
        self.setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        self.setBackgroundImage(UIImage(named:bgImageName+"_highlighted"), for: .highlighted)
        self.setImage(UIImage(named:imageName), for: .normal)
        self.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        self.sizeToFit()

    }
    
}
