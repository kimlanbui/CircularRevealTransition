//
//  CircularRevealTransition.swift
//  Pods
//
//  Created by Kim Lan Bui on 07/02/17.
//
//

import UIKit

open class CircularRevealAnimation {
    let startPoint : CGPoint
    let endFrame : CGRect
    let maskLayer : CAShapeLayer
    let startPath : UIBezierPath
    let endPath : UIBezierPath
    
    public init(from point: CGPoint, to frame: CGRect) {
        startPoint = point
        endFrame = frame
        
        let radius = sqrt(endFrame.width * endFrame.width + endFrame.height * endFrame.height) / 2
        
        startPath = UIBezierPath(arcCenter: startPoint, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        endPath = UIBezierPath(arcCenter: CGPoint(x: endFrame.width / 2, y: endFrame.height / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = startPath.cgPath
        layer.frame = endFrame
        
        maskLayer = layer
    }
    
    public func shape() -> CAShapeLayer {
        return maskLayer
    }
    
    public func commit(duration: TimeInterval, expand isExpanding: Bool, completionBlock block: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = duration
        
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
        let startingPoint = CGPoint(x: sourceFrame.minX + sourceFrame.width / 2, y: sourceFrame.minY + sourceFrame.height / 2)
        
        let animation = CircularRevealAnimation(from: startingPoint, to: toViewFrame)
        let maskLayer = animation.shape()
        
        if isExpanding {
            toViewController.view.layer.mask = maskLayer
        }
        else {
            fromViewController.view.layer.mask = maskLayer
        }
        
        animation.commit(duration: transitionDuration(using: transitionContext),
                         expand:  isExpanding,
                         completionBlock: {
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view.layer.mask = nil
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view.layer.mask = nil
        })
    }
}
