//
//  PhotoBrowerAnmation.swift
//  PhotoBrowser
//
//  Created by chenzhen on 2019/7/9.
//  Copyright © 2019 LYW. All rights reserved.
//

import UIKit

class PhotoBrowerAnmation: NSObject {
    
    var isPresented : Bool = false
    
    // 定义indexPath和presentedDelegate属性
    var indexPath : NSIndexPath?
    // 定义弹出的presentedDelegate
    var presentedDelegate : PhotoBrowserPresentedDelegate?
    // 定义消失的DismissDelegate
    var dismissDelegate : PhotoBrowserDismissDelegate?

}

protocol PhotoBrowserPresentedDelegate : NSObjectProtocol {
    // 1.提供弹出的imageView
    func imageForPresent(indexPath : NSIndexPath) -> UIImageView
    
    // 2.提供弹出的imageView的frame
    func startRectForPresent(indexPath : NSIndexPath) -> CGRect
    
    // 3.提供弹出后imageView的frame
    func endRectForPresent(indexPath : NSIndexPath) -> CGRect
}

protocol PhotoBrowserDismissDelegate : NSObjectProtocol {
    // 1.提供退出的imageView
    func imageViewForDismiss() -> UIImageView
    
    // 2.提供退出的indexPath
    func indexPathForDismiss() -> NSIndexPath
}




extension PhotoBrowerAnmation : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowerAnmation : UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? presentedView(using: transitionContext) : dissmissedView(using: transitionContext)
    }
    
    
    func presentedView(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        // 1.取出弹出的View
        let presentedView = transitionContext.view(forKey: .to)
        transitionContext.containerView.addSubview(presentedView!)
        //取图片做动画
        let tempImageView = presentedDelegate.imageForPresent(indexPath: indexPath)
        transitionContext.containerView.addSubview(tempImageView)
        
        tempImageView.frame = presentedDelegate.startRectForPresent(indexPath: indexPath)
        
        // 3.执行动画
        presentedView!.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImageView.frame = presentedDelegate.endRectForPresent(indexPath: indexPath)
        }) { (_) in
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
            tempImageView.removeFromSuperview()
            presentedView!.alpha = 1.0
        }

    }
    
    
    func dissmissedView(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        // 1.取出消失的View
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.alpha = 0
        //取出图片做动画
        let tempImageView = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(tempImageView)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImageView.frame = presentedDelegate.startRectForPresent(indexPath: dismissDelegate.indexPathForDismiss())

        }) { (_) in
            tempImageView.removeFromSuperview()
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
