//
//  BAScaleTransition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BAScaleTransition
public class BAScaleTransition: NSObject {
    
    fileprivate let inTransition = BAScaleInTransition(inTransition: true)
    fileprivate let outTransition = BAScaleOutTransition(inTransition: false)
    
    static let rectScale = CGFloat(0.33)
    
    convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.inTransition.baseTransitionInTime = animationDuration
        self.outTransition.baseTransitionOutTime = animationDuration
    }
}

//MARK: - BAScaleTransition (UIViewControllerTransitioningDelegate)
extension BAScaleTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - BAScaleInTransition
private class BAScaleInTransition: BATransition {

    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.transform = CGAffineTransform(scaleX: 1.0 - BAScaleTransition.rectScale, y: 1.0 - BAScaleTransition.rectScale)
        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseOut], animations: {
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.alpha = 1.0
            fromVC.view.transform = CGAffineTransform(scaleX: 1.0 + BAScaleTransition.rectScale, y: 1.0 + BAScaleTransition.rectScale)
            fromVC.view.alpha = 0.9
        }) { (_) in
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.alpha = 1.0
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

//MARK: - BAScaleOutTransition
private class BAScaleOutTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.transform = CGAffineTransform(scaleX: 1.0 + BAScaleTransition.rectScale, y: 1.0 + BAScaleTransition.rectScale)
        toVC.view.alpha = 0.9
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseOut], animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 1.0 - BAScaleTransition.rectScale, y: 1.0 - BAScaleTransition.rectScale)
            fromVC.view.alpha = 0.0
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.alpha = 1.0
        }) { (_) in
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.alpha = 1.0
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
