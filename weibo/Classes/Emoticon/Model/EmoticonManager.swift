//
//  EmoticonManager.swift
//  weibo
//
//  Created by dalu on 2016/11/5.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init(){
        packages.append(EmoticonPackage(""))
        packages.append(EmoticonPackage("com.sina.default"))
        packages.append(EmoticonPackage("com.apple.emoji"))
        packages.append(EmoticonPackage("com.sina.lxh"))
    }
}
