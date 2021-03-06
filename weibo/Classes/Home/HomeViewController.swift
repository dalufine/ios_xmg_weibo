//
//  HomeViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController : BaseViewController {
    lazy var titleBtn : TitleButton = TitleButton()
    
    //在闭包中如果使用当前对象的属性或者调用方法，需要加上self,闭包里面的代码好像不能自动提示
    //内部存在循环引用，当前强引用闭包，闭包内部引用了self，所以需要加上弱引用，此时闭包里面的self就是可选类型了
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self](presented)->() in
        self?.titleBtn.isSelected = presented
    }
    
    lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    lazy var statusModels : [StatusViewModel] = [StatusViewModel]()
    
    lazy var tipLablel : UILabel = UILabel()
    var isTipAnimateFinished = true
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.startRotationAnim()
        if(!isLogin){
            return
        }
        setupNavigationBar()
        //loadStatuses()
        //自动计算高度，自动根据子控件的大小来计算高度，因为把底部工具栏距离底边的约束给删除了，这条不在起作用
        //tableView.rowHeight = UITableViewAutomaticDimension
        //设置估算高度
        tableView.estimatedRowHeight=200
        //去掉分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        setupHeaderView()
        setupFooterView()
        setupTipView()
        setupNatifications()
    }
    
}

// MARK: - UI
extension HomeViewController{
    func setupNatifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrower(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: nil)
    }
    ///自定义navigation
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("dalu", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    //添加下拉刷新
    func setupHeaderView(){
        let headerView = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadLatestStatus))
        
        headerView?.setTitle("下拉刷新", for: .idle)
        headerView?.setTitle("释放更新", for: .pulling)
        headerView?.setTitle("加载中...", for: .refreshing)
        
        tableView.mj_header = headerView
        tableView.mj_header.beginRefreshing()
    }
    
    //添加上拉加载更多
    func setupFooterView(){
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadOldestStatus))
    }
    
    //提示
    func setupTipView(){
        navigationController?.navigationBar.insertSubview(tipLablel, at: 0)
        tipLablel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        tipLablel.backgroundColor = UIColor.orange
        tipLablel.textAlignment = .center
        tipLablel.font = UIFont.systemFont(ofSize: 14)
        tipLablel.textColor = UIColor.white
        tipLablel.isHidden = true
        self.tipLablel.alpha = 0
    }
}

// MARK: - 事件监听
extension HomeViewController{
    func showPhotoBrower(note : Notification){
        let indexPath = note.userInfo![ShowPhotoBrowerIndexKey] as! IndexPath
        let picUrls = note.userInfo![ShowPhotoBrowerUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        let photoBrowserVc = PhotoBrowserViewController(indexPath: indexPath, picUrls: picUrls)
        photoBrowserVc.modalPresentationStyle = .custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        //设置转场代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        present(photoBrowserVc, animated: true, completion: nil)
    }
    
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
    // 加载最新的数据
    func loadLatestStatus(){
        loadStatuses(isNewData: true)
    }
    
    func loadOldestStatus(){
        loadStatuses(isNewData: false)
    }
    
    
    func loadStatuses(isNewData : Bool){
        
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = statusModels.first?.status?.mid ?? 0
        }else{
            max_id = statusModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0: (max_id-1)
        }
        
        
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) {(result, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let resultArray = result else{
                return
            }
            
            var statusModels_tmp : [StatusViewModel] = [StatusViewModel]()
            for dict in resultArray {
                let status = Status(dict: dict)
                statusModels_tmp.append(StatusViewModel(status: status))
            }
            if isNewData {
                self.statusModels = statusModels_tmp + self.statusModels
            }else{
                self.statusModels = self.statusModels + statusModels_tmp
            }
            //self.tableView.reloadData()
            //缓存最新的图片
            self.cachePicFromURLs(viewModels: statusModels_tmp)
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
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //显示提示
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    private func showTipLabel(count : Int){
        guard isTipAnimateFinished else {
            return
        }
        isTipAnimateFinished = false
        tipLablel.isHidden = false
        tipLablel.text = count == 0 ? "没有新数据" : "\(count)条新数据"
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLablel.frame.origin.y = 44
            self.tipLablel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLablel.frame.origin.y = 10
                self.tipLablel.alpha = 0
                }, completion: { (_) in
                    self.isTipAnimateFinished = true
                    self.tipLablel.isHidden = true
            })
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
