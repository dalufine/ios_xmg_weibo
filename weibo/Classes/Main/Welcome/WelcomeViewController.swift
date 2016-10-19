//
//  WelcomeViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/18.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileStr = UserAccountViewModel.shareIntance.account?.avatar_large
        //?? 如果profileStr这个可选类型有值，则对profileStr解包并赋值，如果为nil则用??后面的值来赋值
        let url = URL(string: profileStr ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default"))
        //改变约束
        iconBottomCons.constant = UIScreen.main.bounds.height - 200
        //枚举类型不想传参，使用默认值的话 用 []
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
    
}
