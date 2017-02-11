//
//  CircularRevealTransitionDelegate.swift
//  Pods
//
//  Created by Kim Lan Bui on 11/02/17.
//
//

import UIKit

public class CircularRevealTransitionDelegate : NSObject {
    
    let sourceFrame : CGRect
    let duration : NSTimeInterval
    
    public init(frame: CGRect, duration: NSTimeInterval = 0.3) {
        self.sourceFrame = frame
        self.duration = duration
    }
    
}

extension CircularRevealTransitionDelegate : UIViewControllerTransitioningDelegate {
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransition(frame: sourceFrame, duration: duration, expanding: true)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransition(frame: sourceFrame, duration: duration, expanding: false)
    }
    
}
