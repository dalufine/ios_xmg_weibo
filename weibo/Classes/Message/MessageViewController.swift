//
//  MessageViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVistorViewInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发的消息，都会在这里收到通知")
    }
}
