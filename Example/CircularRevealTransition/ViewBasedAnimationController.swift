//
//  ViewBasedAnimationController.swift
//  CircularRevealTransition
//
//  Created by Kim Lan Bui on 18/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CircularRevealTransition

class ViewBasedAnimationController : UIViewController {
    @IBOutlet var button: UIButton!
    @IBOutlet var fromView: UIView!
    @IBOutlet var toView: UIView!
    
    @IBAction func buttonTapped(_ sender: UIButton?) {
        startAnimation();
    }
    
    func startAnimation() {
        let animation = CircularRevealAnimation(from: CGPoint(x: fromView.bounds.width / 2, y: fromView.bounds.height / 2), to: toView.bounds)
        toView.layer.mask = animation.shape()
        toView.alpha = 1
        animation.commit(duration: 0.3, expand: true, completionBlock: {
            self.toView.layer.mask = nil
        })
    }
    
    
}
