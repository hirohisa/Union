//
//  PresentationController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 5/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {

    let overlay: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.blackColor()

        return view
    }()

    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        overlay.gestureRecognizers = [UITapGestureRecognizer(target: self, action: "overlayDidTouch:")]
    }

    override func presentationTransitionWillBegin() {

        overlay.frame = containerView.bounds
        overlay.alpha = 0.0
        containerView.insertSubview(overlay, atIndex: 0)

        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
            self.overlay.alpha = 0.5
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
            self.overlay.alpha = 0.0
            }, completion: nil)
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
        }
    }

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width / 2, height: parentSize.height)
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        let origin = CGPoint(x: 0, y: 0)
        let size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerView.bounds.size)

        return CGRect(origin: origin, size: size)
    }

    override func containerViewWillLayoutSubviews() {
        overlay.frame = containerView.bounds
        self.presentedView().frame = frameOfPresentedViewInContainerView()
    }

    override func containerViewDidLayoutSubviews() {
    }

    func overlayDidTouch(sender: AnyObject) {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}