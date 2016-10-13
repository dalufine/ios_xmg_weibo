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
    lazy var selectedImageNames = ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
    lazy var composeBtn : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupItems()
    }
}

extension MainViewController{
    /// 初始化添加button 在视频中 方法和lazy前面都可以加private，但我写的却不行，可能是swift3的缘故
    func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        
        composeBtn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: .highlighted)
        composeBtn.sizeToFit()
        
        composeBtn.center=CGPoint(x: tabBar.center.x, y: tabBar.bounds.height*0.5)
    }
    
    func setupItems(){
        for i in 0..<tabBar.items!.count{
            let item = tabBar.items![i]
            if(i==2){
                item.isEnabled = false
                continue
            }
            item.selectedImage = UIImage(named: selectedImageNames[i]+"_highlighted")
        }
    }
}
