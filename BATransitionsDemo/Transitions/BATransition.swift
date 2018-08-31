//
//  BATransition.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

//MARK: BATransition
public class BATransition: NSObject {
    
    public var inTransition: Bool = true
    
    public var animationCompletion: ((_ animation: CAAnimation, _ finished: Bool) -> Void)?
    
    public convenience init(inTransition: Bool) {
        self.init()
        self.inTransition = inTransition
    }
    
    public var baseTransitionInTime: TimeInterval = 0.5
    public var baseTransitionOutTime: TimeInterval = 0.5
    
    public func setupTransition(inTransition: Bool, time: TimeInterval) -> BATransition {
        self.inTransition = inTransition
        
        if inTransition {
            self.baseTransitionInTime = time
        } else {
            self.baseTransitionOutTime = time
        }
        
        return self
    }
}

//MARK: - BATransition (UIViewControllerAnimatedTransitioning)
extension BATransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.inTransition ? self.baseTransitionInTime : self.baseTransitionOutTime
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("override me")
    }
}

//MARK: - BATransition (CAAnimationDelegate)
extension BATransition: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationCompletion?(anim, flag)
    }
}

//MARK: - SlideDirection
public enum SlideDirection {
    case fromLeft
    case fromRight
    case fromTop
    case fromBottom
    
    public var invert: SlideDirection {
        switch self {
        case .fromLeft:
            return .fromRight
        case .fromRight:
            return .fromLeft
        case .fromTop:
            return .fromBottom
        case .fromBottom:
            return .fromTop
        }
    }
}

//MARK: - BAGapDirection
public enum BAGapDirection {
    case fromCenterHorizontal
    case toCenterHorizontal
    case fromCenterVertical
    case toCenterVertical
    case fromCenterHorizontalMasked
    case toCenterHorizontalMasked
}
