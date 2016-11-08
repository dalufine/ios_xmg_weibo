//
//  PhotoBrowserAnimator.swift
//  weibo
//
//  Created by dalu on 2016/11/8.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
}
//面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : IndexPath) -> CGRect
    func endRect(indexPath : IndexPath) -> CGRect
    func imageView(indexPath : IndexPath) -> UIImageView
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ?
            animationForPresentedView(transitionContext: transitionContext)
            :
            animationForDismissView(transitionContext: transitionContext)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentedView)
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.alpha = 1.0
        }, completion:{(_) in
            transitionContext.completeTransition(true)
        })
    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        transitionContext.containerView.addSubview(dismissView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.alpha = 0.0
        }, completion:{(_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

