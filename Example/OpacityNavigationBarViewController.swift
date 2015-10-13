//
//  OpacityNavigationBarViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 10/13/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union

class OpacityNavigationBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Opacity"
        navigationController?.delegate = self
    }
}

extension OpacityNavigationBarViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        if let animationController = animationController as? Union.Navigator where animationController.operation == .Pop {
            return animationController
        }

        return nil
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Union.Navigator.animate(operation)
    }

}