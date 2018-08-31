//
//  BASwap1Transition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BASwap1Transition
public class BASwap1Transition: NSObject {
    
    fileprivate let inTransition = _BASwap1InTransition(inTransition: true)
    fileprivate let outTransition = _BASwap1InTransition(inTransition: false)
    
    public var slideFrom = SlideDirection.fromLeft {
        didSet {
            self.inTransition.slideFrom = slideFrom
            self.outTransition.slideFrom = slideFrom.invert
        }
    }
    
    convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.inTransition.baseTransitionInTime = animationDuration
        self.outTransition.baseTransitionOutTime = animationDuration
    }
}

//MARK: - BASwap1Transition (UIViewControllerTransitioningDelegate)
extension BASwap1Transition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - _BASwap1InTransition
private class _BASwap1InTransition: BATransition {
    
    fileprivate var slideFrom = SlideDirection.fromLeft
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        let scaleTransform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        containerView.addSubview(toVC.view)
        var frame = transitionContext.finalFrame(for: toVC)
        switch self.slideFrom {
        case .fromLeft:
            frame.origin.x -= frame.width
        case .fromRight:
            frame.origin.x += frame.width
        case .fromTop:
            frame.origin.y -= frame.height
        case .fromBottom:
            frame.origin.y += frame.height
        }
        toVC.view.frame = frame
        toVC.view.transform = scaleTransform
        toVC.view.alpha = 0.5
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: part10 * 5.0, animations: {
                var frame = transitionContext.initialFrame(for: fromVC)
                switch self.slideFrom {
                case .fromLeft:
                    frame.origin.x += frame.width * 0.25
                case .fromRight:
                    frame.origin.x -= frame.width * 0.25
                case .fromTop:
                    frame.origin.y += frame.height * 0.25
                case .fromBottom:
                    frame.origin.y -= frame.height * 0.25
                }
                
                fromVC.view.frame = frame
                fromVC.view.transform = scaleTransform
                fromVC.view.alpha = 0.5
                
                frame = transitionContext.finalFrame(for: toVC)
                switch self.slideFrom {
                case .fromLeft:
                    frame.origin.x -= frame.width * 0.25
                case .fromRight:
                    frame.origin.x += frame.width * 0.25
                case .fromTop:
                    frame.origin.y -= frame.height * 0.25
                case .fromBottom:
                    frame.origin.y += frame.height * 0.25
                }
                
                toVC.view.transform = CGAffineTransform.identity
                toVC.view.frame = frame
                toVC.view.transform = scaleTransform
            })
            UIView.addKeyframe(withRelativeStartTime: part10 * 5.0, relativeDuration: part10 * 5.0, animations: {
                toVC.view.transform = CGAffineTransform.identity
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
                toVC.view.alpha = 1.0
                
                var frame = transitionContext.initialFrame(for: fromVC)
                switch self.slideFrom {
                case .fromLeft:
                    frame.origin.x += frame.width
                case .fromRight:
                    frame.origin.x -= frame.width
                case .fromTop:
                    frame.origin.y += frame.height
                case .fromBottom:
                    frame.origin.y -= frame.height
                }
                fromVC.view.transform = CGAffineTransform.identity
                fromVC.view.frame = frame
                fromVC.view.transform = scaleTransform
            })
        }) { (_) in
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.frame = transitionContext.finalFrame(for: fromVC)
            fromVC.view.alpha = 1.0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
