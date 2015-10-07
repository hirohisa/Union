//
//  Union.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 2/19/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol Delegate {
    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation]
    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation]
}

extension Delegate {

    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation] {
        return []
    }
    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation] {
        return []
    }
}

class Manager: NSObject {

    var duration: NSTimeInterval {
        return before.duration + present.duration
    }

    let before = AnimationManager()
    let present = AnimationManager()

    func startAnimation(context: UIViewControllerContextTransitioning) {

        setup(context)

        before.completion = {
            self.startTransition(context)
        }

        before.start()
    }
}

extension Manager: UIViewControllerAnimatedTransitioning {

    func animateTransition(context: UIViewControllerContextTransitioning) {
        startAnimation(context)
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

private extension Manager {

    // MARK: setup animations before running

    func setup(context: UIViewControllerContextTransitioning) {
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let fromViewController = fromViewController, let toViewController = toViewController {
            setupAnimations(fromViewController: fromViewController, toViewController: toViewController)
        }
    }

    func setupAnimations(fromViewController fromViewController: UIViewController, toViewController: UIViewController) {
        // before
        let fromViewController = findViewControllerIn(fromViewController)
        let toViewController = findViewControllerIn(toViewController)

        if let delegate = fromViewController as? Delegate {
            before.animations = delegate.animationsBeforeTransitionTo(toViewController)
        }

        // present
        var animations = [Animation]()
        if let delegate = fromViewController as? Delegate {
            animations += delegate.animationsDuringTransitionFrom(fromViewController)
        }
        if let delegate = toViewController as? Delegate {
            animations += delegate.animationsDuringTransitionFrom(fromViewController)
        }

        present.animations = animations
    }

    // MARK: run with animation animations

    func startTransition(context: UIViewControllerContextTransitioning) {
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let toView = toViewController?.view, let fromView = fromViewController?.view {

            switch context.presentationStyle() {
            case .None:
                context.containerView()!.insertSubview(toView, aboveSubview: fromView)
            default:
                // context.containerView() is UIPresentationController.view
                if !fromView.isDescendantOfView(context.containerView()!) {
                    context.containerView()!.insertSubview(toView, aboveSubview: fromView)
                }
                break
            }
        }

        present.completion = {
            switch context.presentationStyle() {
            case .None:
                fromViewController?.view.removeFromSuperview()
            default:
                break
            }

            context.completeTransition(true)
        }
        present.start()
    }

    func findViewControllerIn(viewController: UIViewController) -> UIViewController {

        switch viewController {
        case let navigationController as UINavigationController:
            return navigationController.topViewController!
        default:
            break
        }

        return viewController
    }
}

public func animate() -> UIViewControllerAnimatedTransitioning? {
    return Manager()
}