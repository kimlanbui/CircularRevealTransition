//
//  ViewController.swift
//  CircularRevealTransition
//
//  Created by kim.lan.bui@gmx.net on 02/07/2017.
//  Copyright (c) 2017 kim.lan.bui@gmx.net. All rights reserved.
//

import UIKit
import CircularRevealTransition

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        transitionDelegate = CircularRevealTransitionDelegate(frame: button.frame)
        let destinationController = segue.destination
        destinationController.transitioningDelegate = transitionDelegate
        // destinationController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
    }
    
    @IBAction func unwindFromView(_ segue: UIStoryboardSegue) {}
    
    deinit {
        print("remove ViewController")
    }
}

class BlueViewController : UIViewController {
    
    var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    @IBAction func didTapButton(_ sender: UIButton!) {
        transitionDelegate = CircularRevealTransitionDelegate(frame: sender.frame)
        transitioningDelegate = transitionDelegate
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
