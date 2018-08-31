//
//  BAGapTransition.swift
//  BATransitionsDemo
//
//  Created by Alexandr Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BAGapTransition
public class BAGapTransition: NSObject {
    
    fileprivate let fromCenterHorizontal: BATransition = {
        return BAGapFromCenterHorizontalTransition()
    }()
    
    fileprivate let toCenterHorizontal: BATransition = {
       return BAGapToCenterHorizontalTransition()
    }()
    
    fileprivate let fromCenterVertical: BATransition = {
        return BAGapFromCenterVerticalTransition()
    }()
    
    fileprivate let toCenterVertical: BATransition = {
        return BAGapToCenterVerticalTransition()
    }()
    
    fileprivate let fromCenterHorizontalMasked: BATransition = {
       return BAGapFromCenterHorizontalMaskedTransition()
    }()
    
    fileprivate let toCenterHorizontalMasked: BATransition = {
        return BAGapToCenterHorizontalMaskedTransition()
    }()
    
    public var gapDirection = BAGapDirection.fromCenterHorizontal
    
    public var animationDuration: TimeInterval = 0.5
    
    fileprivate var inTransition: BATransition {
        switch self.gapDirection {
        case .fromCenterHorizontal:
            return self.fromCenterHorizontal.setupTransition(inTransition: true, time: self.animationDuration)
        case .toCenterHorizontal:
            return self.toCenterHorizontal.setupTransition(inTransition: true, time: self.animationDuration)
        case .fromCenterVertical:
            return self.fromCenterVertical.setupTransition(inTransition: true, time: self.animationDuration)
        case .toCenterVertical:
            return self.toCenterVertical.setupTransition(inTransition: true, time: self.animationDuration)
        case .fromCenterHorizontalMasked:
            return self.fromCenterHorizontalMasked.setupTransition(inTransition: true, time: self.animationDuration)
        case .toCenterHorizontalMasked:
            return self.toCenterHorizontalMasked.setupTransition(inTransition: true, time: self.animationDuration)
        }
    }
    
    fileprivate var outTransition: BATransition {
        switch self.gapDirection {
        case .fromCenterHorizontal:
            return self.toCenterHorizontal.setupTransition(inTransition: false, time: self.animationDuration)
        case .toCenterHorizontal:
            return self.fromCenterHorizontal.setupTransition(inTransition: false, time: self.animationDuration)
        case .fromCenterVertical:
            return self.toCenterVertical.setupTransition(inTransition: false, time: self.animationDuration)
        case .toCenterVertical:
            return self.fromCenterVertical.setupTransition(inTransition: false, time: self.animationDuration)
        case .fromCenterHorizontalMasked:
            return self.toCenterHorizontalMasked.setupTransition(inTransition: false, time: self.animationDuration)
        case .toCenterHorizontalMasked:
            return self.fromCenterHorizontalMasked.setupTransition(inTransition: false, time: self.animationDuration)
        }
    }
    
    convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.animationDuration = animationDuration
    }
}

//MARK: - BAGapTransition (UIViewControllerTransitioningDelegate)
extension BAGapTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - BAGapFromCenterHorizontalTransition
private class BAGapFromCenterHorizontalTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        fromVC.view.removeFromSuperview()
        containerView.addSubview(toVC.view)
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toVC.view.alpha = 0.75
        
        var snapshots = [UIView]()
        let frame = transitionContext.initialFrame(for: fromVC)
        let frameWidthDiv2 = frame.width * 0.5
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(i) * frameWidthDiv2, y: frame.origin.y),
                                       size: CGSize(width: frameWidthDiv2, height: frame.height))
            let snapshot = fromVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            containerView.addSubview(snapshot)
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: part10 * 5.0, animations: {
                let firstView = snapshots[0], secondView = snapshots[1]
                var frame = firstView.frame
                frame.origin.x -= frame.width
                firstView.frame = frame
                
                frame = secondView.frame
                frame.origin.x += frame.width
                secondView.frame = frame
            })
            UIView.addKeyframe(withRelativeStartTime: part10 * 5.0, relativeDuration: part10 * 5.0, animations: {
                toVC.view.transform = CGAffineTransform.identity
                toVC.view.alpha = 1.0
            })
        }, completion: { (_) in
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

//MARK: - BAGapToCenterHorizontalTransition
private class BAGapToCenterHorizontalTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        var snapshots = [UIView]()
        var frame = transitionContext.finalFrame(for: toVC)
        let frameWidthDiv2 = frame.width * 0.5
        let toVCSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(i) * frameWidthDiv2, y: frame.origin.y),
                                       size: CGSize(width: frameWidthDiv2, height: frame.height))
            let snapshot = toVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            containerView.addSubview(snapshot)
        }
        
        let firstView = snapshots[0], secondView = snapshots[1]
        frame = firstView.frame
        frame.origin.x -= frameWidthDiv2
        firstView.frame = frame
        
        frame = secondView.frame
        frame.origin.x += frameWidthDiv2
        secondView.frame = frame
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: part10 * 5.0, animations: {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                fromVC.view.alpha = 0.75
            })
            UIView.addKeyframe(withRelativeStartTime: part10 * 5.0, relativeDuration: part10 * 5.0, animations: {
                frame = firstView.frame
                frame.origin.x += frame.width
                firstView.frame = frame
                
                frame = secondView.frame
                frame.origin.x -= frame.width
                secondView.frame = frame
            })
        }, completion: { (_) in
            let _ = snapshots.map({ $0.removeFromSuperview() })
            containerView.addSubview(toVC.view)

            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.alpha = 1.0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

//MARK: - BAGapFromCenterVerticalTransition
private class BAGapFromCenterVerticalTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        fromVC.view.removeFromSuperview()
        containerView.addSubview(toVC.view)
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toVC.view.alpha = 0.75
        
        var snapshots = [UIView]()
        let frame = transitionContext.initialFrame(for: fromVC)
        let frameHeightDiv2 = frame.height * 0.5
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: CGFloat(i) * frameHeightDiv2),
                                       size: CGSize(width: frame.width, height: frameHeightDiv2))
            let snapshot = fromVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            containerView.addSubview(snapshot)
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: part10 * 5.0, animations: {
                let firstView = snapshots[0], secondView = snapshots[1]
                var frame = firstView.frame
                frame.origin.y -= frame.height
                firstView.frame = frame
                
                frame = secondView.frame
                frame.origin.y += frame.height
                secondView.frame = frame
            })
            UIView.addKeyframe(withRelativeStartTime: part10 * 5.0, relativeDuration: part10 * 5.0, animations: {
                toVC.view.transform = CGAffineTransform.identity
                toVC.view.alpha = 1.0
            })
        }, completion: { (_) in
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

//MARK: - BAGapToCenterVerticalTransition
private class BAGapToCenterVerticalTransition: BATransition {
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        var snapshots = [UIView]()
        var frame = transitionContext.finalFrame(for: toVC)
        let frameHeightDiv2 = frame.height * 0.5
        let toVCSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: CGFloat(i) * frameHeightDiv2),
                                       size: CGSize(width: frame.width, height: frameHeightDiv2))
            let snapshot = toVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            containerView.addSubview(snapshot)
        }
        
        let firstView = snapshots[0], secondView = snapshots[1]
        frame = firstView.frame
        frame.origin.y -= frameHeightDiv2
        firstView.frame = frame
        
        frame = secondView.frame
        frame.origin.y += frameHeightDiv2
        secondView.frame = frame
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: part10 * 5.0, animations: {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                fromVC.view.alpha = 0.75
            })
            UIView.addKeyframe(withRelativeStartTime: part10 * 5.0, relativeDuration: part10 * 5.0, animations: {
                frame = firstView.frame
                frame.origin.y += frame.height
                firstView.frame = frame
                
                frame = secondView.frame
                frame.origin.y -= frame.height
                secondView.frame = frame
            })
        }, completion: { (_) in
            let _ = snapshots.map({ $0.removeFromSuperview() })
            containerView.addSubview(toVC.view)
            
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.alpha = 1.0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

//MARK: - BAGapFromCenterHorizontalMaskedTransition
private class BAGapFromCenterHorizontalMaskedTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        fromVC.view.removeFromSuperview()
        containerView.addSubview(toVC.view)
        
        var snapshots = [UIView]()
        var frame = transitionContext.initialFrame(for: fromVC)
        let frameWidthDiv2 = frame.width * 0.5
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(i) * frameWidthDiv2, y: frame.origin.y),
                                       size: CGSize(width: frameWidthDiv2, height: frame.height))
            let snapshot = fromVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            let maskLayer = CAShapeLayer()
            let snapshotMaskBeginFrame = CGRect(origin: CGPoint.zero, size: snapshotFrame.size)
            maskLayer.path = CGPath(rect: snapshotMaskBeginFrame, transform: nil)
            snapshot.layer.mask = maskLayer
            snapshot.layer.masksToBounds = true
            
            containerView.addSubview(snapshot)
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        self.animationCompletion = { [weak self] (_ animation: CAAnimation, _ finished: Bool) in
            self?.animationCompletion = nil
            
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let firstView = snapshots[0], maskLayer1 = firstView.layer.mask as! CAShapeLayer
        let secondView = snapshots[1], maskLayer2 = secondView.layer.mask as! CAShapeLayer
        
        frame = firstView.frame
        let newPath1 = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 0.0, height: frame.height)))
        frame = secondView.frame
        let newPath2 = UIBezierPath(rect: CGRect(origin: CGPoint(x: frame.width, y: 0.0), size: CGSize(width: 0.0, height: frame.height)))
        
        let animation1 = CABasicAnimation(keyPath: "path")
        animation1.fromValue = maskLayer1.path
        animation1.toValue = newPath1.cgPath
        animation1.duration = part10 * 5.0
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation1.delegate = self
        maskLayer1.add(animation1, forKey: nil)
        
        let animation2 = CABasicAnimation(keyPath: "path")
        animation2.fromValue = maskLayer2.path
        animation2.toValue = newPath2.cgPath
        animation2.duration = part10 * 5.0
        animation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        maskLayer2.add(animation2, forKey: nil)
    
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer1.path = newPath1.cgPath
        maskLayer2.path = newPath2.cgPath
        CATransaction.commit()
    }
}

//MARK: - BAGapToCenterHorizontalMaskedTransition
private class BAGapToCenterHorizontalMaskedTransition: BATransition {
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        fromVC.view.removeFromSuperview()
        containerView.addSubview(toVC.view)
        
        var snapshots = [UIView]()
        var frame = transitionContext.initialFrame(for: fromVC)
        let frameWidthDiv2 = frame.width * 0.5
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        
        for i in 0...1 {
            let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(i) * frameWidthDiv2, y: frame.origin.y),
                                       size: CGSize(width: frameWidthDiv2, height: frame.height))
            let snapshot = fromVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
            snapshot.frame = snapshotFrame
            snapshots.append(snapshot)
            
            let maskLayer = CAShapeLayer()
            snapshot.layer.mask = maskLayer
            snapshot.layer.masksToBounds = true
            
            containerView.addSubview(snapshot)
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        self.animationCompletion = { [weak self] (_ animation: CAAnimation, _ finished: Bool) in
            self?.animationCompletion = nil
            
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let firstView = snapshots[0], maskLayer1 = firstView.layer.mask as! CAShapeLayer
        let secondView = snapshots[1], maskLayer2 = secondView.layer.mask as! CAShapeLayer
        
        frame = firstView.frame
        let beginPath1 = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: frame.size))
        maskLayer1.path = beginPath1.cgPath
        let newPath1 = UIBezierPath(rect: CGRect(origin: CGPoint(x: frame.width, y: 0.0), size: CGSize(width: 0.0, height: frame.height)))
        
        frame = secondView.frame
        let beginPath2 = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: frame.size))
        maskLayer2.path = beginPath2.cgPath
        let newPath2 = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 0.0, height: frame.height)))
        
        let animation1 = CABasicAnimation(keyPath: "path")
        animation1.fromValue = maskLayer1.path
        animation1.toValue = newPath1.cgPath
        animation1.duration = part10 * 5.0
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation1.delegate = self
        maskLayer1.add(animation1, forKey: nil)
        
        let animation2 = CABasicAnimation(keyPath: "path")
        animation2.fromValue = maskLayer2.path
        animation2.toValue = newPath2.cgPath
        animation2.duration = part10 * 5.0
        animation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        maskLayer2.add(animation2, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer1.path = newPath1.cgPath
        maskLayer2.path = newPath2.cgPath
        CATransaction.commit()
    }
}
