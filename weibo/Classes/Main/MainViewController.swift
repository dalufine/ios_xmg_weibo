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

// MARK: - 设置UI界面
extension MainViewController{
    /// 初始化添加button 在视频中 方法和lazy前面都可以加private，但我写的却不行，可能是swift3的缘故
    func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        composeBtn.center=CGPoint(x: tabBar.center.x, y: tabBar.bounds.height*0.5)
        
        //Selector的写法"composeBtnClick"(已经废弃)或者#selector(MainViewController.composeBtnClick)
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    
}
// MARK: - 事件监听
extension MainViewController{
    //如果方法加上private，该方法不会被添加到方法列表中，事件监听的本质是发送消息，而发送消息是OC的特性，它需要从方法列表中查找方法，如果需要添加private来限定访问，则需要下面的写法：@objc private
    func composeBtnClick(){
        let composeVc = ComposeController()
        let composeNav = UINavigationController(rootViewController: composeVc)
        
        present(composeNav, animated: true, completion: nil)
    }
}
