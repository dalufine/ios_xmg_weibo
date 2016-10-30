//
//  PicPickerViewCell.swift
//  weibo
//
//  Created by dalu on 2016/10/30.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    var image : UIImage? {
        didSet{
            if image != nil{
                photoView.isHidden = false
                photoView.image = image
                imageBtn.isUserInteractionEnabled = false
                delBtn.isHidden = false
            }else{
                delBtn.isHidden = true
                photoView.image = nil
                photoView.isHidden = true
                imageBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //多层传递 用通知的方式，而不推荐用 闭包和代理
    @IBAction func addPhoto() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func delPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerDelPhotoNote), object: photoView.image)
    }
    
}
