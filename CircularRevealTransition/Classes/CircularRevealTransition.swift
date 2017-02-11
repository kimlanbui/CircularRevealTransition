//
//  CircularRevealTransition.swift
//  Pods
//
//  Created by Kim Lan Bui on 07/02/17.
//
//

import UIKit

public class CircularRevealTransition : NSObject {
    
    var transitionContext : UIViewControllerContextTransitioning?
    let sourceFrame : CGRect
    let isExpanding : Bool
    let duration : NSTimeInterval
    
    public init(frame: CGRect, duration: NSTimeInterval = 0.3, expanding: Bool = true) {
        self.sourceFrame = frame
        self.isExpanding = expanding
        self.duration = duration
    }
    
}

extension CircularRevealTransition : UIViewControllerAnimatedTransitioning {
    
    @objc public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                return
        }
        
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
        maskLayer.path = startPath.CGPath
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
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view.layer.mask = nil
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view.layer.mask = nil
        })
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.duration = transitionDuration(transitionContext)
        
        if isExpanding {
            pathAnimation.fromValue = startPath.CGPath
            pathAnimation.toValue = endPath.CGPath
            maskLayer.path = endPath.CGPath
        }
        else {
            pathAnimation.fromValue = endPath.CGPath
            pathAnimation.toValue = startPath.CGPath
            maskLayer.path = startPath.CGPath
        }
        
        maskLayer.addAnimation(pathAnimation, forKey: "circularRevealAnimation")
        
        CATransaction.commit()
    }
}
