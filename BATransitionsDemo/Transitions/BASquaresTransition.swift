//
//  BASquaresTransition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BASquaresTransition
public class BASquaresTransition: NSObject {
    
    fileprivate let inTransition = BASquaresInTransition(inTransition: true)
    fileprivate let outTransition = BASquaresOutTransition(inTransition: false)
    
    public convenience init(animationDuration: TimeInterval) {
        self.init()
        
        self.inTransition.baseTransitionInTime = animationDuration
        self.outTransition.baseTransitionOutTime = animationDuration
    }
}

//MARK: - BASquaresTransition (UIViewControllerTransitioningDelegate)
extension BASquaresTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.outTransition
    }
}

//MARK: - BASquaresInTransition
private class BASquaresInTransition: BATransition {
    
    fileprivate var widthCount: Int = 4
    fileprivate var heightCount: Int = 8
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let frame = transitionContext.finalFrame(for: toVC)
        
        let snapshotSize = CGSize(width: frame.width / CGFloat(self.widthCount), height: frame.height / CGFloat(self.heightCount))
        
        var snapshots = [UIView]()
        
        let toVCSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)!

        for x in 0..<self.widthCount {
            for y in 0..<self.heightCount {
                let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(x) * snapshotSize.width, y: CGFloat(y) * snapshotSize.height), size: snapshotSize)
                let snapshot = toVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
                snapshot.frame = snapshotFrame
                snapshot.alpha = 0.0
                
                let maskLayer = CAShapeLayer()
                let snapshotMaskBeginFrame = CGRect(origin: CGPoint.zero, size: snapshotFrame.size).insetBy(dx: snapshotFrame.width * 0.5, dy: snapshotFrame.height * 0.5)
                maskLayer.path = CGPath(rect: snapshotMaskBeginFrame, transform: nil)
                snapshot.layer.mask = maskLayer
                snapshot.layer.masksToBounds = true
                
                containerView.addSubview(snapshot)
                
                snapshots.append(snapshot)
            }
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        var firstAnimation: CAAnimation!
        for snapshot in snapshots {
            let snapshotMaskEndFrame = CGRect(origin: CGPoint.zero, size: snapshot.frame.size)
            
            let maskLayer = snapshot.layer.mask as? CAShapeLayer
            let newPath = CGPath(rect: snapshotMaskEndFrame, transform: nil)
            
            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = maskLayer?.path
            maskAnimation.toValue = newPath
            maskAnimation.duration = part10 * 10.0
            maskAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            if firstAnimation == nil {
                firstAnimation = maskAnimation
                firstAnimation.delegate = self
            }
            maskLayer?.add(maskAnimation, forKey: nil)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer?.path = newPath
            CATransaction.commit()
        }
        
        self.animationCompletion = { [weak self] (_ animation: CAAnimation, _ finished: Bool) in
            self?.animationCompletion = nil
            
            containerView.bringSubview(toFront: toVC.view)
            
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: part10 * 5.0, delay: 0.0, options: .curveLinear, animations: {
            for snapshot in snapshots {
                snapshot.alpha = 1.0
            }
        }, completion: nil)
    }
}

//MARK: - BASquaresOutTransition
private class BASquaresOutTransition: BATransition {
    
    fileprivate var widthCount: Int = 4
    fileprivate var heightCount: Int = 8
    
    fileprivate override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let xCount = CGFloat(self.widthCount), yCount = CGFloat(self.heightCount)
        
        let frame = transitionContext.finalFrame(for: toVC)
        let snapshotSize = CGSize(width: frame.width / xCount, height: frame.height / yCount)
        
        var snapshots = [UIView]()
        
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        
        for x in 0..<self.widthCount {
            for y in 0..<self.heightCount {
                let snapshotFrame = CGRect(origin: CGPoint(x: CGFloat(x) * snapshotSize.width, y: CGFloat(y) * snapshotSize.height), size: snapshotSize)
                let snapshot = fromVCSnapshot.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
                snapshot.frame = snapshotFrame
                containerView.addSubview(snapshot)
                
                let maskLayer = CAShapeLayer()
                let snapshotMaskBeginFrame = CGRect(origin: CGPoint.zero, size: snapshotFrame.size)
                maskLayer.path = CGPath(rect: snapshotMaskBeginFrame, transform: nil)
                snapshot.layer.mask = maskLayer
                snapshot.layer.masksToBounds = true
                
                snapshots.append(snapshot)
            }
        }

        containerView.sendSubview(toBack: fromVC.view)

        let animationDuration = self.transitionDuration(using: transitionContext)
        let part10 = animationDuration * 0.1
        
        var firstAnimation: CAAnimation!
        for snapshot in snapshots {
            let snapshotFrame = CGRect(origin: CGPoint.zero, size: snapshot.frame.size)
            let snapshotMaskEndFrame = snapshotFrame.insetBy(dx: snapshotFrame.width * 0.5, dy: snapshotFrame.height * 0.5)
            
            let maskLayer = snapshot.layer.mask as? CAShapeLayer
            let newPath = CGPath(rect: snapshotMaskEndFrame, transform: nil)
            
            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = maskLayer?.path
            maskAnimation.toValue = newPath
            maskAnimation.duration = part10 * 10.0
            maskAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            if firstAnimation == nil {
                firstAnimation = maskAnimation
                firstAnimation.delegate = self
            }
            maskLayer?.add(maskAnimation, forKey: nil)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer?.path = newPath
            CATransaction.commit()
        }
        
        self.animationCompletion = { [weak self] (_ animation: CAAnimation, _ finished: Bool) in
            self?.animationCompletion = nil
        }
        
        UIView.animate(withDuration: part10 * 10.0, delay: 0.0, options: .curveLinear, animations: {
            for snapshot in snapshots {
                snapshot.alpha = 0.0
            }
        }) { (_) in
            containerView.bringSubview(toFront: toVC.view)
            
            let _ = snapshots.map({ $0.removeFromSuperview() })
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
