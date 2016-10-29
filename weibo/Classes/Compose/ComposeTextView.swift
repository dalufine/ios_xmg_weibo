//
//  ComposeTextView.swift
//  weibo
//
//  Created by dalu on 2016/10/29.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SnapKit
// MARK: - 因为源生的TextView不能使用hint
class ComposeTextView: UITextView {
   
    lazy var hintLable : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
}

// MARK: - 设置UI
extension ComposeTextView{
    func setupUI(){
        addSubview(hintLable)
        hintLable.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        hintLable.textColor = UIColor.gray
        hintLable.font = font
        hintLable.text = "分享新鲜事..."
        //
        textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 5, right: 10)
    }
}
