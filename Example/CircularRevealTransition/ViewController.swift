//
//  ViewController.swift
//  CircularRevealTransition
//
//  Created by kim.lan.bui@gmx.net on 02/07/2017.
//  Copyright (c) 2017 kim.lan.bui@gmx.net. All rights reserved.
//

import UIKit
import CircularRevealTransition

class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    
    let transition = CircularRevealTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController
        destinationController.transitioningDelegate = self
        destinationController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
    }
}

extension ViewController : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = button.center
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        return transition
    }
}

