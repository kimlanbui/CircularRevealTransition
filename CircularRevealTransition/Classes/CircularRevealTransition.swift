//
//  CircularRevealTransition.swift
//  Pods
//
//  Created by Kim Lan Bui on 07/02/17.
//
//

import UIKit

open class CircularRevealTransition : NSObject {
    
    var transitionContext : UIViewControllerContextTransitioning?
    let sourceFrame : CGRect
    let isExpanding : Bool
    let duration : TimeInterval
    
    public init(frame: CGRect, duration: TimeInterval = 0.3, expanding: Bool = true) {
        self.sourceFrame = frame
        self.isExpanding = expanding
        self.duration = duration
    }
    
}

extension CircularRevealTransition : UIViewControllerAnimatedTransitioning {
    
    @objc public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    @objc public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        if isExpanding {
            containerView.addSubview(toViewController.view)
        }
        else {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        
        let toViewFrame = toViewController.view.frame
        let radius = sqrt(toViewFrame.width * toViewFrame.width + toViewFrame.height * toViewFrame.height)
        
        let startPath = UIBezierPath(arcCenter: CGPoint(x: sourceFrame.minX + sourceFrame.width / 2, y: sourceFrame.minY + sourceFrame.height / 2), radius: 1, startAngle: 0, endAngle: 360, clockwise: true)
        let endPath = UIBezierPath(arcCenter: CGPoint(x: toViewFrame.width / 2, y: toViewFrame.height / 2), radius: radius / 2, startAngle: 0, endAngle: 360, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = startPath.cgPath
        maskLayer.frame = toViewController.view.frame
        
        if isExpanding {
            toViewController.view.layer.mask = maskLayer
        }
        else {
            fromViewController.view.layer.mask = maskLayer
        }
        
        // create the animation
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view.layer.mask = nil
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view.layer.mask = nil
        })
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = transitionDuration(using: transitionContext)
        
        if isExpanding {
            pathAnimation.fromValue = startPath.cgPath
            pathAnimation.toValue = endPath.cgPath
            maskLayer.path = endPath.cgPath
        }
        else {
            pathAnimation.fromValue = endPath.cgPath
            pathAnimation.toValue = startPath.cgPath
            maskLayer.path = startPath.cgPath
        }
        
        maskLayer.add(pathAnimation, forKey: "circularRevealAnimation")
        
        CATransaction.commit()
    }
}
