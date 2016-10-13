//
//  MainViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //从json文件中获取
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)else{
            print("没有获取到文件路径")
            return
        }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) as? Data else {
            print("没有获取到json数据")
            return
        }
        
        guard let dictobject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else{
            return
        }
        
        guard let dictArray = dictobject as? [[String:Any]] else{
            return
        }
        
        for dict in dictArray{
            //print(dict)
            guard let vcName = dict["vcName"] as? String else{
                continue
            }
            guard let title = dict["title"] as? String else{
                continue
            }
            guard let imageName = dict["imageName"] as? String else{
                continue
            }
            addChildViewController(vcName, title: title, imageName: imageName)
        }
        
        /**
         //直接获取
         addChildViewController(HomeViewController(), title: "首页", imageName: "tabbar_home")
         addChildViewController(DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
         addChildViewController(MessageViewController(), title: "消息", imageName: "tabbar_message_center")
         addChildViewController(ProfileViewController(), title: "我", imageName: "tabbar_profile")
         **/
    }
    
    /// 添加子tab，父类也有addChildViewController这个方法，这里重构了，么有复写;
    /// private标识只有当前文件可以访问，不是当前类，在当前文件可以有多个类，都是可以访问的
    private func addChildViewController(_ childController: UIViewController,title: String,imageName: String) {
        
        //tabBar.tintColor = UIColor.orange
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        let childNav = UINavigationController(rootViewController: childController)
        addChildViewController(childNav)
        
    }
    
    ///如果不是直接传递的controller对象，而是类名，需要采用下面的创建方式
    private func addChildViewController(_ childVcName:String,title: String,imageName: String) {
        
        //let childVcName = "HomeViewController"
        //获取命名空间 从 Info.plist中获取
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else{
            print("没有获取的命名空间")
            return
        }
        //获取class
        guard let childVcClass = NSClassFromString(nameSpace+"."+childVcName) else {
            print("没有获取的对应的类")
            return
        }
        //将childVcClass AnyClass转为控制器类型
        guard let childType = childVcClass as? UIViewController.Type else{
            print("没有获取的对应的控制器类型")
            return
        }
        let childController = childType.init()
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        let childNav = UINavigationController(rootViewController: childController)
        addChildViewController(childNav)
        
    }
}
