//
//  PresentingViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 10/13/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union

class PresentingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "overlay", style: .Plain, target: self, action: "showPresentation")
    }


    func showPresentation() {

        let viewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .Custom
        navigationController.transitioningDelegate = self

        presentViewController(navigationController, animated: true, completion: nil)
    }

}


extension PresentingViewController: UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {

        return PresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return Union.Presenter.animate()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return Union.Presenter.animate()
    }
    
}