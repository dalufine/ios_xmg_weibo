//
//  PopoverAnimator.swift
//  weibo
//
//  Created by dalu on 2016/10/15.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    // MARK: - 向外提供的参数
    var presentedFrame : CGRect = CGRect.zero
    var isPresent = false
    
    // MARK: - 定义闭包
    //闭包默认为 () -> () 因为没有给初始化，所以定义为下面可选类型的格式
    var callBack : ((_ isPresented : Bool) -> ())?
    
    override init(){
    }
    //如果自定义了一个构造函数，却没有对默认的init()方法重写，则自定义的会覆盖默认
    init(callBack : @escaping (_ isPresented : Bool) -> ()) {
        self.callBack = callBack
    }
    
}

extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    ///改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = DLUIPresentationController(presentedViewController: presented, presenting: presenting)
        present.presentedFrame = presentedFrame
        return present
    }
    
    ///自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        callBack!(isPresent)
        return self
    }
    
    ///自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        callBack!(isPresent)
        return self
    }
}

extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
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
