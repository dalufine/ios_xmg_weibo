//
//  PhotoBrowserAnimator.swift
//  weibo
//
//  Created by dalu on 2016/11/8.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

//面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : IndexPath) -> CGRect
    func endRect(indexPath : IndexPath) -> CGRect
    func imageView(indexPath : IndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDissmiss() -> IndexPath
    func imageView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    var indexPath : IndexPath?
    var presentedDelegate : AnimatorPresentedDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
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
        return 0.5
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        guard let presentedDelegate = presentedDelegate , let indexPath = indexPath else {
            return
        }
        
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentedView)
        let statRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = statRect
        //
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }, completion:{(_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        })
    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        
        guard  let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        //transitionContext.containerView.addSubview(dismissView)
        dismissView?.removeFromSuperview()
        //
        let imageView = dismissDelegate.imageView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDissmiss()
        //
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }, completion:{(_) in
            transitionContext.completeTransition(true)
        })
    }
}

