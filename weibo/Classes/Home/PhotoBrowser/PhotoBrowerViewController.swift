//
//  PhotoBrowerViewController.swift
//  weibo
//
//  Created by dalu on 2016/11/7.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserViewController: UIViewController {
    var indexPath : IndexPath
    var picUrls : [URL]
    
    //
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    lazy var closeBtn = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    lazy var saveBtn = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width = view.frame.size.width + 20
    }
    
    init(indexPath : IndexPath, picUrls : [URL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserViewController{
    func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        //
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK: - Event
extension PhotoBrowserViewController{
    func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    func saveBtnClick(){
        // 1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageview.image else {
            return
        }
        
        // 2.将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

// MARK: - 代理
extension PhotoBrowserViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        cell.backgroundColor = UIColor.black
        return cell
    }
}
extension PhotoBrowserViewController : PhotoBrowserCellDelegate{
    func imageViewClick() {
        closeBtnClick()
    }
}

class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
