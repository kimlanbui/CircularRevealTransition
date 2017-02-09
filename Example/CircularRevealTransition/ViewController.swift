//
//  ViewController.swift
//  CircularRevealTransition
//
//  Created by kim.lan.bui@gmx.net on 02/07/2017.
//  Copyright (c) 2017 kim.lan.bui@gmx.net. All rights reserved.
//

import UIKit

class Animator : NSObject, UIViewControllerAnimatedTransitioning {
    var transitionContext : UIViewControllerContextTransitioning?
    let sourceFrame : CGRect
    let isExpanding : Bool
    
    init(frame : CGRect, expanding: Bool = true) {
        sourceFrame = frame
        isExpanding = expanding
    }
    
    @objc internal func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    @objc internal func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                return
        }
        
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        let toViewFrame = toViewController.view.frame
        let radius = sqrt(toViewFrame.width * toViewFrame.width + toViewFrame.height * toViewFrame.height)
        
        let smallPath = UIBezierPath(arcCenter: CGPoint(x: sourceFrame.minX + sourceFrame.width / 2, y: sourceFrame.minY + sourceFrame.height / 2), radius: 1, startAngle: 0, endAngle: 360, clockwise: true)
        
        let bigPath = UIBezierPath(arcCenter: CGPoint(x: toViewFrame.width / 2, y: toViewFrame.height / 2), radius: radius / 2, startAngle: 0, endAngle: 360, clockwise: true)
        
        let maskPath = isExpanding ? smallPath : bigPath
        let circlePath = isExpanding ? bigPath : smallPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        maskLayer.frame = toViewController.view.frame
        toViewController.view.layer.mask = maskLayer
        
        // create the animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = maskPath.CGPath
        pathAnimation.toValue = circlePath
        pathAnimation.duration = transitionDuration(transitionContext)
        maskLayer.path = circlePath.CGPath
        maskLayer.addAnimation(pathAnimation, forKey: "pathAnimation")
        
    }
    
    internal func animationEnded(transitionCompleted: Bool) {
        guard let transitionContext = transitionContext else {
            return
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view.layer.mask = nil
    }
}

class TransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    let sourceFrame : CGRect
    
    init(frame : CGRect) {
        sourceFrame = frame
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(frame: sourceFrame, expanding: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(frame: sourceFrame, expanding: false)
    }
}

class ViewController : UIViewController {
    
    @IBOutlet var button: UIButton!
    
    var transitionDelegate: UIViewControllerTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        transitionDelegate = TransitioningDelegate(frame: button.frame)
        let destinationController = segue.destinationViewController
        destinationController.transitioningDelegate = transitionDelegate
        // destinationController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
    }
    
    @IBAction func unwindFromView(segue: UIStoryboardSegue) {}
}

class BlueViewController : UIViewController {
    
    var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    @IBAction func didTapButton(sender: UIButton!) {
        transitionDelegate = TransitioningDelegate(frame: sender.frame)
        transitioningDelegate = transitionDelegate
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
