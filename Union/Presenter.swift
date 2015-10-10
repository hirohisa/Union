//
//  Presenter.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 10/7/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class Presenter: NSObject {

    let before = AnimationManager()
    let present = AnimationManager()

    var duration: NSTimeInterval {
        return before.duration + present.duration
    }

    func animate(transitionContext: UIViewControllerContextTransitioning) {
        setup(transitionContext)
        start(transitionContext)
    }

    public class func animate() -> UIViewControllerAnimatedTransitioning {
        return Presenter()
    }
}

extension Presenter: UIViewControllerAnimatedTransitioning {

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext)
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

extension Presenter {

    func setup(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let fromViewController = fromViewController, let toViewController = toViewController {
            _setup(fromViewController: fromViewController, toViewController: toViewController)
        }
    }

    func start(transitionContext: UIViewControllerContextTransitioning) {
        before.completion = { [unowned self] in
            self.startTransition(transitionContext)
        }
        before.start()
    }

    func startTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            transitionContext.completeTransition(true)
            return
        }
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let toView = toViewController?.view, let fromView = fromViewController?.view {
            switch transitionContext.presentationStyle() {
            case .None:
                containerView.insertSubview(toView, aboveSubview: fromView)
            default:
                // context.containerView() is UIPresentationController.view
                if !fromView.isDescendantOfView(containerView) {
                    containerView.insertSubview(toView, aboveSubview: fromView)
                }
                break
            }
        }

        present.completion = {
            switch transitionContext.presentationStyle() {
            case .None:
                fromViewController?.view?.removeFromSuperview()
            default:
                break
            }

            transitionContext.completeTransition(true)
        }
        present.start()
    }

    private func _setup(fromViewController fromViewController: UIViewController, toViewController: UIViewController) {

        if let delegate = fromViewController as? Delegate {
            before.animations = delegate.animationsBeforeTransitionTo(toViewController)
        }

        // present
        var fromAnimations: [Animation] = []
        if let delegate = fromViewController as? Delegate {
            fromAnimations = delegate.animationsBeforeTransitionTo(toViewController)
        }
        var toAnimation: [Animation] = []
        if let delegate = toViewController as? Delegate {
            toAnimation = delegate.animationsDuringTransitionFrom(fromViewController)
        }

        present.animations = fromAnimations + toAnimation
    }
}