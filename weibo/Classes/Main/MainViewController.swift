//
//  MainViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit


class MainViewController: UITabBarController {
    // MARK: - 懒加载
    lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
        //阻止items中间按钮的点击事件，在SB中设置了（这样composeBtn才能点击到），不需要在调用isEnable
    }
    
}

extension MainViewController{
    /// 初始化添加button 在视频中 方法和lazy前面都可以加private，但我写的却不行，可能是swift3的缘故
    func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        composeBtn.center=CGPoint(x: tabBar.center.x, y: tabBar.bounds.height*0.5)
    }
    
}
