//
//  Union.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 2/19/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol Delegate {
    func tasksBeforeTransitionTo(viewController: UIViewController) -> [Task]
    func tasksDuringTransitionFrom(viewController: UIViewController) -> [Task]
}

extension Delegate {

    func tasksBeforeTransitionTo(viewController: UIViewController) -> [Task] {
        return []
    }
    func tasksDuringTransitionFrom(viewController: UIViewController) -> [Task] {
        return []
    }
}

class Manager: NSObject {

    var duration: NSTimeInterval {
        return before.duration + present.duration
    }

    let before = Animator()
    let present = Animator()

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

    // MARK: setup tasks before running

    func setup(context: UIViewControllerContextTransitioning) {
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let fromViewController = fromViewController, let toViewController = toViewController {
            setupTasks(fromViewController: fromViewController, toViewController: toViewController)
        }
    }

    func setupTasks(fromViewController fromViewController: UIViewController, toViewController: UIViewController) {
        // before
        let fromViewController = findViewControllerIn(fromViewController)
        let toViewController = findViewControllerIn(toViewController)

        if let delegate = fromViewController as? Delegate {
            before.tasks = delegate.tasksBeforeTransitionTo(toViewController)
        }

        // present
        var tasks = [Task]()
        if let delegate = fromViewController as? Delegate {
            tasks += delegate.tasksDuringTransitionFrom(fromViewController)
        }
        if let delegate = toViewController as? Delegate {
            tasks += delegate.tasksDuringTransitionFrom(fromViewController)
        }

        present.tasks = tasks
    }

    // MARK: run with animation tasks

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