//
//  EmoticonViewCell.swift
//  weibo
//
//  Created by dalu on 2016/11/5.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //
    
    lazy var emoticonBtn = UIButton()
    //
    var emoticon : Emoticon?{
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named : "compose_emotion_delete"), for: .normal)
            }
        }
    }
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init err")
    }
}

extension EmoticonViewCell{
    func setupUI(){
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.frame
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
