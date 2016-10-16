//
//  ProfileViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVistorViewInfo("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料都会显示在这里，展示给别人")
    }
    
}
