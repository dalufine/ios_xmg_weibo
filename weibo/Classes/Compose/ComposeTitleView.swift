//
//  CompseTitleView.swift
//  weibo
//
//  Created by dalu on 2016/10/29.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - 构造方法
class ComposeTitleView: UIView {
    
    lazy var titleLabel: UILabel = UILabel()
    lazy var screenNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension ComposeTitleView {
    func setupUI(){
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //cons
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        //
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    }
}
