//
//  PicCollectionView.swift
//  weibo
//
//  Created by dalu on 2016/10/23.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    var picUrls : [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //在SB中，不能把数据源设置为自己，只有在代码里面设置
        dataSource = self
        delegate = self
        
    }
}

extension PicCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //通知
        let userInfo = [ShowPhotoBrowerIndexKey: indexPath,ShowPhotoBrowerUrlsKey: picUrls] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: self, userInfo: userInfo)
    }
}
//
extension PicCollectionView : AnimatorPresentedDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        //获取cell
        let cell = self.cellForItem(at: indexPath)!
        //将当前cell的frame转换为相对于手机屏幕的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        //获取该位置的image对象
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)!
        //计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0.0
        if h < UIScreen.main.bounds.height {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)!
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        //超出部分裁剪
        imageView.clipsToBounds = true
        return imageView
    }
    
    
}

//item控件
class PicCollectionViewCell : UICollectionViewCell {
    //
    var picUrl : URL?{
        didSet{
            guard let picUrl = picUrl else{
                return
            }
            picImageview.sd_setImage(with: picUrl, placeholderImage: UIImage(named : "empty_picture"))
        }
    }
    
    //
    @IBOutlet weak var picImageview: UIImageView!
    
}

