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
    }
}

extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
}

//item控件
class PicCollectionViewCell: UICollectionViewCell {
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
