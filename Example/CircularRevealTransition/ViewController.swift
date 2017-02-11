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
        return 3
    }
    
    @objc internal func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
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
        if isExpanding {
            pathAnimation.fromValue = startPath.CGPath
            pathAnimation.toValue = endPath.CGPath
        }
        else {
            pathAnimation.fromValue = endPath.CGPath
            pathAnimation.toValue = startPath.CGPath
        }
        pathAnimation.duration = transitionDuration(transitionContext)
        
        if isExpanding {
            maskLayer.path = endPath.CGPath
        }
        else {
            maskLayer.path = startPath.CGPath
        }
        
        maskLayer.addAnimation(pathAnimation, forKey: "pathAnimation")
        
        CATransaction.commit()
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
    
    deinit {
        print("remove ViewController")
    }
}

class BlueViewController : UIViewController {
    
    var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    @IBAction func didTapButton(sender: UIButton!) {
        transitionDelegate = TransitioningDelegate(frame: sender.frame)
        transitioningDelegate = transitionDelegate
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
