//
//  EmoticonViewController.swift
//  weibo
//
//  Created by dalu on 2016/11/4.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonViewController: UIViewController {
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonViewLayout())
    lazy var toolBar : UIToolbar = UIToolbar()
    lazy var manager = EmoticonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI
extension EmoticonViewController{
    func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        //
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar": toolBar,"collectionView": collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        preparCollectionView()
        prepareToolbar()
    }
    
    func preparCollectionView(){
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func prepareToolbar() {
        
        let titles = ["最近","默认","emoji","浪小花"]
        var index = 0
        var tempItems = [UIBarButtonItem]()
        
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action:#selector(EmoticonViewController.toolbarClick(item:)))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    func toolbarClick(item : UIBarButtonItem){
        let tag = item.tag
        let indexPath = IndexPath(item: 0, section: tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension EmoticonViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //
        insertRecentlyEmoticon(emoticon: emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon){
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        //
        if (manager.packages.first?.emoticons.contains(emoticon))!{
            let index = manager.packages.first?.emoticons.index(of: emoticon)
            manager.packages.first?.emoticons.remove(at: index!)
        }else{
            manager.packages.first?.emoticons.remove(at: 19)
        }
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}


class EmoticonViewLayout : UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
        
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH ) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
    
}
