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
            setupContent(picUrl: picUrl)
        }
    }
    //
    lazy var scrollView = UIScrollView()
    lazy var imageview = UIImageView()
    lazy var progressView : ProgressView = ProgressView()
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
        contentView.addSubview(progressView)
        scrollView.addSubview(imageview)
        //
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width = scrollView.frame.size.width - 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
    }
}

extension PhotoBrowserViewCell{
    func setupContent(picUrl : URL?){
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
        //imageview.image = image
        progressView.isHidden = false
        imageview.sd_setImage(with: getBigURL(picUrl), placeholderImage: image, options: [], progress: {(current, total) -> Void in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }, completed: {
            (_,_,_,_) -> Void in
            self.progressView.isHidden = true
        })
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    func getBigURL(_ smallUrl : URL) -> URL{
        let smallurlString = smallUrl.absoluteString
        //bmiddle  large
        let bigURLString = smallurlString.replacingOccurrences(of: "thumbnail", with: "large")
        return URL(string: bigURLString)!
    }
}
