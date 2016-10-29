//
//  HomeViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController : BaseViewController {
    lazy var titleBtn : TitleButton = TitleButton()
    
    //在闭包中如果使用当前对象的属性或者调用方法，需要加上self,闭包里面的代码好像不能自动提示
    //内部存在循环引用，当前强引用闭包，闭包内部引用了self，所以需要加上弱引用，此时闭包里面的self就是可选类型了
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self](presented)->() in
        self?.titleBtn.isSelected = presented
    }
    
    lazy var statusModels : [StatusViewModel] = [StatusViewModel]()
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.startRotationAnim()
        if(!isLogin){
            return
        }
        setupNavigationBar()
        loadStatuses()
        //自动计算高度，自动根据子控件的大小来计算高度，因为把底部工具栏距离底边的约束给删除了，这条不在起作用
        //tableView.rowHeight = UITableViewAutomaticDimension
        //设置估算高度
        tableView.estimatedRowHeight=200
        //去掉分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
}

// MARK: - UI
extension HomeViewController{
    ///自定义navigation
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("dalu", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK: - 事件监听
extension HomeViewController{
    func titleBtnClick(_ titleBtn:TitleButton){
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popoverVc = PopoverViewController()
        
        //设置控制器的modal样式，不然popoverVc弹出后，下面的VC会被回收
        popoverVc.modalPresentationStyle = .custom
        
        //设置转场代理可以是其他对象
        popoverVc.transitioningDelegate = popoverAnimator
        
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        present(popoverVc, animated: true, completion: nil)
        
    }
}

//请求数据
extension HomeViewController{
    func loadStatuses(){
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let resultArray = result else{
                return
            }
            
            for dict in resultArray {
                let status = Status(dict: dict)
                self.statusModels.append(StatusViewModel(status: status))
            }
            //刷新数据
            //self.tableView.reloadData()
            self.cachePicFromURLs(viewModels: self.statusModels)
        }
    }
    //缓存图片用于获取图片大小
    func cachePicFromURLs(viewModels : [StatusViewModel]) {
        //创建group
        let group = DispatchGroup()
        
        
        for viewMode in viewModels {
            for picUrl in viewMode.picUrls {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
}

//因为本身是tabviewcontroller，所以不需要遵守协议
extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID")!
        //
        //        let statusModel = statusModels[indexPath.row]
        //        cell.textLabel?.text = statusModel.sourceText
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        
        cell.viewModel = statusModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = statusModels[indexPath.row]
        return viewModel.cellHeight
    }
}
