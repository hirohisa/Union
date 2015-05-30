//
//  Union.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 2/19/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

@objc
public protocol Delegate {
    optional func tasksBeforeTransitionTo(viewController: UIViewController) -> [Task]
    optional func tasksDuringTransitionFrom(viewController: UIViewController) -> [Task]
}

class Manager: NSObject {

    var duration: NSTimeInterval {
        return before.duration + present.duration
    }

    let before = Animator()
    let present = Animator()

    func animate(context: UIViewControllerContextTransitioning) {

        setup(context)

        before.completion = {
            self.startTransition(context)
        }

        before.start()
    }
}

extension Manager: UIViewControllerAnimatedTransitioning {

    func animateTransition(context: UIViewControllerContextTransitioning) {
        animate(context)
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
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

    func setupTasks(#fromViewController: UIViewController, toViewController: UIViewController) {
        // before
        let fromViewController = findViewControllerIn(fromViewController)
        let toViewController = findViewControllerIn(toViewController)

        if let delegate = fromViewController as? Delegate, let _tasks = delegate.tasksBeforeTransitionTo?(toViewController) {
            before.tasks = _tasks
        }

        // present
        var tasks: [Task] = [Task]()
        if let delegate = fromViewController as? Delegate, let _tasks = delegate.tasksDuringTransitionFrom?(fromViewController) {
            tasks += _tasks
        }
        if let delegate = toViewController as? Delegate, let _tasks = delegate.tasksDuringTransitionFrom?(fromViewController) {
            tasks += _tasks
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
                context.containerView().insertSubview(toView, aboveSubview: fromView)
            default:
                // context.containerView() is UIPresentationController.view
                if !fromView.isDescendantOfView(context.containerView()) {
                    context.containerView().insertSubview(toView, aboveSubview: fromView)
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
            return navigationController.topViewController
        default:
            break
        }

        return viewController
    }
}

public func animate() -> UIViewControllerAnimatedTransitioning? {
    return Manager()
}