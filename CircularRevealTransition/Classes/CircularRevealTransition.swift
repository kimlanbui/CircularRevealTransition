//
//  CircularRevealTransition.swift
//  Pods
//
//  Created by Kim Lan Bui on 07/02/17.
//
//

import UIKit

public class CircularRevealTransition : NSObject {
    
    public enum Mode {
        case present
        case dismiss
        case pop
    }
    
    public var startingPoint: CGPoint = CGPointZero
    public var duration: NSTimeInterval = 0.5
    public var transitionMode: Mode = .present
    public var color: UIColor = UIColor.whiteColor()
    
    private var transitionView: UIView = UIView()
    
    private var transitionContext: UIViewControllerContextTransitioning?
    
    func frame(with center: CGPoint, size: CGSize, transitionStart: CGPoint) -> CGRect {
        let width = fmaxf(Float(transitionStart.x), Float(size.width - transitionStart.x))
        let height = fmaxf(Float(transitionStart.y), Float(size.height - transitionStart.y))
        let offset = sqrt(width * width + height * height) * 2
        return CGRect(x: 0, y: 0, width: CGFloat(offset), height: CGFloat(offset))
    }
}

extension CircularRevealTransition : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let container = transitionContext.containerView() else {
            return
        }
        
        switch transitionMode {
        case .present:
            guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
            }
            guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
                return
            }
            container.addSubview(fromView)
            container.addSubview(toView)
            
            let center = toView.center
            let size = toView.frame.size
            let mask = UIBezierPath(ovalInRect: frame(with: center, size: size, transitionStart: startingPoint))
            let layer = CAShapeLayer()
            layer.frame = toView.frame
            layer.path = mask.CGPath
            toView.layer.mask = layer
            
            let endPath = UIBezierPath(ovalInRect: toView.frame)
            
            // create the animation
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.delegate = self
            pathAnimation.fromValue = mask.CGPath
            pathAnimation.toValue = endPath
            pathAnimation.duration = transitionDuration(transitionContext)
            layer.path = endPath.CGPath
            layer.addAnimation(pathAnimation, forKey: "pathAnimation")
            
            /*
            transitionView = UIView(frame: frame(with: center, size: size, transitionStart: startingPoint))
            transitionView.layer.cornerRadius = transitionView.frame.size.height / 2
            transitionView.center = startingPoint
            transitionView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            transitionView.backgroundColor = color
            container.addSubview(transitionView)
            
            presentedView.center = startingPoint
            presentedView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            presentedView.alpha = 0
            container.addSubview(presentedView)
            
            UIView.animateWithDuration(duration,
                                       animations: {
                                        self.transitionView.transform = CGAffineTransformIdentity
                                        presentedView.transform = CGAffineTransformIdentity
                                        presentedView.alpha = 1
                                        presentedView.center = center
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(true)
            })
            */
        default:
            let key = (transitionMode == .pop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey
            guard let revealedView = transitionContext.viewForKey(key) else {
                return
            }
            
            let center = revealedView.center
            let size = revealedView.frame.size
            
            transitionView.frame = frame(with: center, size: size, transitionStart: startingPoint)
            transitionView.layer.cornerRadius = transitionView.frame.size.height / 2
            transitionView.center = startingPoint
            
            UIView.animateWithDuration(duration,
                                       animations: {
                                        self.transitionView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                                        revealedView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                                        revealedView.center = self.startingPoint
                                        revealedView.alpha = 0
                                        
                                        if self.transitionMode == .pop {
                                            container.insertSubview(revealedView, belowSubview: revealedView)
                                            container.insertSubview(self.transitionView, belowSubview: revealedView)
                                        }
                }, completion: { finished in
                    revealedView.removeFromSuperview()
                    self.transitionView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    override public func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if let transitionContext = self.transitionContext {
            transitionContext.completeTransition(true)
        }
    }
}
