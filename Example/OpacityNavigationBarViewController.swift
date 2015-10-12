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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "overlay", style: .Plain, target: self, action: "next")
    }

    func next() {

        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.blueColor()

        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.delegate = self
    }
}

extension OpacityNavigationBarViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print(__FUNCTION__)
        return Union.Navigator.interact()
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(__FUNCTION__)
        return Union.Navigator.animate()
    }

}