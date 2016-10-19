//
//  AppDelegate.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultViewController : UIViewController{
        let isLogin : Bool = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //设置全局的颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        //MainViewController直接使用就行，不需要引入
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}

