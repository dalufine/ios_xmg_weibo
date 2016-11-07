//
//  PhotoBrowserViewCell.swift
//  weibo
//
//  Created by dalu on 2016/11/7.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserViewCell: UICollectionViewCell {
    var picUrl : URL?{
        didSet{
            guard let picUrl = picUrl else {
                return
            }
            guard let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString) else {
                return
            }
            
            //计算比例
            let x : CGFloat = 0
            let width = UIScreen.main.bounds.width
            let height = width / image.size.width * image.size.height
            
            var y : CGFloat = 0
            if height < UIScreen.main.bounds.height {
                y = (UIScreen.main.bounds.height - height) * 0.5
            }
            imageview.frame = CGRect(x: x, y: y, width: width, height: height)
            imageview.image = image
        }
    }
    //
    lazy var scrollView = UIScrollView()
    lazy var imageview = UIImageView()
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowserViewCell{
    func setupUI(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageview)
        //
        scrollView.frame = contentView.bounds
    }
}
