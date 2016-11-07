//
//  HomeViewCell.swift
//  weibo
//
//  Created by dalu on 2016/10/22.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    
    //
    @IBOutlet weak var contentLableCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetTopCons: NSLayoutConstraint!
    
    //
    @IBOutlet weak var retweetContentLabel: HYLabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetbg: UIView!
    @IBOutlet weak var toolView: UIView!
    
    var viewModel : StatusViewModel?{
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            iconView.sd_setImage(with: viewModel.profile_url, placeholderImage: UIImage(named: "avatar_default_small"))
            verifiedView.image = viewModel.verifiedImage
            screenNameLabel.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLabel.text = viewModel.createAtText
            if let attrString = FindEmoticon.shareInstance.findAttrString(statusText: viewModel.status?.text , font: contentLabel.font){
                contentLabel.attributedText = attrString
            }else{
                contentLabel.text = viewModel.status?.text
            }
            
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 \(sourceText)"
            }else{
                sourceLabel.text = nil
            }
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            let picSize = calculatePicSize(count: viewModel.picUrls.count)
            picViewWCons.constant = picSize.width
            picViewHCons.constant = picSize.height
            //设置pic的urls
            picView.picUrls = viewModel.picUrls
            
            if viewModel.status?.retweeted_status != nil {
                if let retweetUsername = viewModel.status?.retweeted_status?.user?.screen_name,let retweetText = viewModel.status?.retweeted_status?.text{
                    let retweetedText = "@\(retweetUsername): "+retweetText
                    if let attrString = FindEmoticon.shareInstance.findAttrString(statusText: retweetedText , font: retweetContentLabel.font){
                        retweetContentLabel.attributedText = attrString
                    }else{
                        retweetContentLabel.text = viewModel.status?.text
                    }
                    retweetTopCons.constant = 15
                }
                retweetbg.isHidden = false
            }else{
                retweetTopCons.constant = 0
                retweetContentLabel.text = nil
                retweetbg.isHidden = true
            }
            
            if viewModel.cellHeight == 0{
                //重新计算cell高度
                layoutIfNeeded()
                viewModel.cellHeight=toolView.frame.maxY
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLableCons.constant = UIScreen.main.bounds.width - 2*edgeMargin
        //尺寸应该根据图片的个数来确定，参考calculatePicSize方法
        //        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //        let imageViewWH = (UIScreen.main.bounds.width - 2*edgeMargin - 2*itemMargin)/3
        //        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            guard let url = URL(string: link) else {
                return
            }
            UIApplication.shared.openURL(url)
        }
        retweetContentLabel.linkTapHandler = { (label, link, range) in
            guard let url = URL(string: link) else {
                return
            }
            UIApplication.shared.openURL(url)
            
        }
    }
}
extension HomeViewCell{
    func calculatePicSize(count : Int) ->CGSize {
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        picViewBottomCons.constant = 10
        
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        if count == 1 {
            //String! SD库会自己解包
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: viewModel?.picUrls.first?.absoluteString)
            
            if let image = image {
                layout.itemSize = CGSize(width: image.size.width*2, height: image.size.height*2)
                return CGSize(width: image.size.width*2, height: image.size.height*2)
            } else {
                return CGSize.zero
            }
            
        }
        
        let imageViewWH = (UIScreen.main.bounds.width - 2*edgeMargin - 2*itemMargin)/3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        if count == 4 {
            let picViewWH = imageViewWH*2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        let rows = CGFloat((count - 1)/3 + 1)
        let picViewH = rows * imageViewWH + (rows - 1)*itemMargin
        let picViewW = UIScreen.main.bounds.width - 2*edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}
