//
//  HomeViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/13.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    var isPresent = false
    lazy var titleBtn : TitleButton = TitleButton()
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.startRotationAnim()
        if(!isLogin){
            return
        }
        setupNavigationBar()
    }
    
}

// MARK: - UI
extension HomeViewController{
    ///自定义navigation
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("dalu", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK: - 事件监听
extension HomeViewController{
    func titleBtnClick(titleBtn:TitleButton){
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popoverVc = PopoverViewController()
        
        //设置控制器的modal样式，不然popoverVc弹出后，下面的VC会被回收
        popoverVc.modalPresentationStyle = .custom
        
        //设置转场代理
        popoverVc.transitioningDelegate = self
        present(popoverVc, animated: true, completion: nil)
        
    }
}


extension HomeViewController : UIViewControllerTransitioningDelegate{
    ///改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DLUIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    ///自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    ///自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension HomeViewController : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    
    //通过转场上下文transitionContext，可以获取弹出(to)和消失(from)的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if(isPresent){
            let presentedView = transitionContext.view(forKey: .to)!
            //将弹出的view放到containerView中，因为重写了这个方法，系统就不会自己放置了
            transitionContext.containerView.addSubview(presentedView)
            
            presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            //设置锚点位置，默认是屏幕中间(0.5 0.5)
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                presentedView.transform = CGAffineTransform.identity
                
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }else{
            let dismissedView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
            }) { (_) in
                dismissedView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
