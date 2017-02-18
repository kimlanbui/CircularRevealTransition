//
//  ViewBasedAnimationController.swift
//  CircularRevealTransition
//
//  Created by Kim Lan Bui on 18/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ViewBasedAnimationController : UIViewController {
    @IBOutlet var button: UIButton!
    @IBOutlet var fromView: UIView!
    @IBOutlet var toView: UIView!
    
    @IBAction func buttonTapped(_ sender: UIButton?) {
        startAnimation();
    }
    
    func startAnimation() {
        
    }
    
    
}
