//
//  PicPickerCollectionView.swift
//  weibo
//
//  Created by dalu on 2016/10/30.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15


class PicPickerCollectionView: UICollectionView {
    var images : [UIImage] = [UIImage]() {
        didSet{
            reloadData()
        }
    }
    
    // MARK: - 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4*edgeMargin)/3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        //xib不支持直接拖动一个cell进去，需要注册，UICollectionViewCell是系统的cell
        //        register(UICollectionViewCell.self, forCellWithReuseIdentifier: picPickerCell)
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        //内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

extension PicPickerCollectionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        cell.image = indexPath.item<=images.count-1 ? images[indexPath.item] : nil
        return cell
    }
}
