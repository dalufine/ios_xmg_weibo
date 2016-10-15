//
//  HomeViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class HomeViewController : BaseViewController {
    lazy var titleBtn : TitleButton = TitleButton()
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator()
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.startRotationAnim()
        if(!isLogin){
            return
        }
        setupNavigationBar()
    }
    
}

// MARK: - UI
extension HomeViewController{
    ///自定义navigation
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("dalu", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK: - 事件监听
extension HomeViewController{
    func titleBtnClick(titleBtn:TitleButton){
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popoverVc = PopoverViewController()
        
        //设置控制器的modal样式，不然popoverVc弹出后，下面的VC会被回收
        popoverVc.modalPresentationStyle = .custom
        
        //设置转场代理可以是其他对象
        popoverVc.transitioningDelegate = popoverAnimator
        
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        present(popoverVc, animated: true, completion: nil)
        
    }
}

