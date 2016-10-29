//
//  ComposeController.swift
//  weibo
//
//  Created by dalu on 2016/10/29.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class ComposeController: UIViewController {
    lazy var titleView : ComposeTitleView  = ComposeTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()

    }
}

// MARK: - 设置UI
extension ComposeController {
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}


// MARK: - 事件
extension ComposeController {
    func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    
    func sendItemClick(){
        dismiss(animated: true, completion: nil)
    }

}
