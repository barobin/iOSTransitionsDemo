//
//  BASlide1Transition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BASlide1Transition
public class BASlide1Transition: NSObject {
    
    fileprivate let inTransition = BASlide1InTransition(inTransition: true)
    fileprivate let outTransition = BASlide1OutTransition(inTransition: false)
    
    public var slideFrom = SlideDirection.fromLeft {
        didSet {
            self.inTransition.slideFrom = slideFrom
            self.outTransition.slideFrom = slideFrom.invert
        }
    }
    
    public convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.inTransition.baseTransitionInTime = animationDuration
        self.outTransition.baseTransitionOutTime = animationDuration
    }
}

//MARK: - BASlide1Transition (UIViewControllerTransitioningDelegate)
extension BASlide1Transition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - BASlide1InTransition
private class BASlide1InTransition: BATransition {
    
    fileprivate var slideFrom = SlideDirection.fromLeft
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        
        var finalFrame = transitionContext.finalFrame(for: toVC)
        switch self.slideFrom {
        case .fromLeft:
            finalFrame.origin.x -= finalFrame.size.width
        case .fromRight:
            finalFrame.origin.x += finalFrame.size.width
        case .fromTop:
            finalFrame.origin.y -= finalFrame.size.height
        case .fromBottom:
            finalFrame.origin.y += finalFrame.size.height
        }
        toVC.view.frame = finalFrame
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: animationDuration * 0.5, animations: { 
                fromVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                fromVC.view.alpha = 0.7
            })
            UIView.addKeyframe(withRelativeStartTime: animationDuration * 0.5, relativeDuration: animationDuration * 0.5, animations: { 
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
            })
        }) { (_) in
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

//MARK: - BASlide1OutTransition
private class BASlide1OutTransition: BATransition {
    
    fileprivate var slideFrom = SlideDirection.fromRight
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        toVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toVC.view.alpha = 0.7
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: animationDuration * 0.5, animations: {
                var finalFrame = transitionContext.finalFrame(for: fromVC)
                switch self.slideFrom {
                case .fromLeft:
                    finalFrame.origin.x += finalFrame.size.width
                case .fromRight:
                    finalFrame.origin.x -= finalFrame.size.width
                case .fromTop:
                    finalFrame.origin.y += finalFrame.size.height
                case .fromBottom:
                    finalFrame.origin.y -= finalFrame.size.height
                }
                fromVC.view.frame = finalFrame
            })
            
            UIView.addKeyframe(withRelativeStartTime: animationDuration * 0.5, relativeDuration: animationDuration * 0.5, animations: { 
                toVC.view.transform = CGAffineTransform.identity
                toVC.view.alpha = 1.0
            })
        }) { (_) in
            fromVC.view.frame = transitionContext.finalFrame(for: fromVC)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
