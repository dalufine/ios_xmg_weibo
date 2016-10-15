//
//  DLUIPresentationController.swift
//  weibo
//
//  Created by dalu on 2016/10/15.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class DLUIPresentationController: UIPresentationController {
    
    lazy var coverView : UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = CGRect(x: 100, y: 55, width: 180, height: 250)
        setupCoverView()
    }

}


extension DLUIPresentationController{
    ///添加蒙层
    func setupCoverView(){
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        //如果前面的containerView为空导致返回nil 回执行??后面的
        coverView.frame = containerView?.bounds ?? CGRect.zero
        containerView?.insertSubview(coverView, at: 0)
        
        let tagGes = UITapGestureRecognizer(target: self, action: #selector(DLUIPresentationController.coverViewClick))
        
        coverView.addGestureRecognizer(tagGes)
    }
}

extension DLUIPresentationController{
    func coverViewClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
