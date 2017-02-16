//
//  CircularRevealTransitionDelegate.swift
//  Pods
//
//  Created by Kim Lan Bui on 11/02/17.
//
//

import UIKit

open class CircularRevealTransitionDelegate : NSObject {
    
    let sourceFrame : CGRect
    let duration : TimeInterval
    
    public init(frame: CGRect, duration: TimeInterval = 0.3) {
        self.sourceFrame = frame
        self.duration = duration
    }
    
}

extension CircularRevealTransitionDelegate : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransition(frame: sourceFrame, duration: duration, expanding: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransition(frame: sourceFrame, duration: duration, expanding: false)
    }
    
}
