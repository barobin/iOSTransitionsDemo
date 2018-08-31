//
//  BAFadeTransition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BAFadeTransition
public class BAFadeTransition: NSObject {
    
    fileprivate let inTransition = BAFadeInTransition(inTransition: true)
    fileprivate let outTransition = BAFadeOutTransition(inTransition: false)
    
    convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.inTransition.baseTransitionInTime = animationDuration
        self.outTransition.baseTransitionOutTime = animationDuration
    }
}

//MARK: - BAFadeTransition (UIViewControllerTransitioningDelegate)
extension BAFadeTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - BAFadeInTransition
private class BAFadeInTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0.0
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
            toViewController.view.alpha = 1.0
        }) { (_) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

//MARK: - BAFadeOutTransition
private class BAFadeOutTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        containerView.sendSubview(toBack: toVC.view);
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
            fromVC.view.alpha = 0.0
        }) { (_) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
