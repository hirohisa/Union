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

// Protocol Animation

protocol CAPropertyAnimationPotocol {
    var valueAfterAnimation: AnyObject { get }
    var keyPath: String! { get set }
}

extension CAPropertyAnimation: CAPropertyAnimationPotocol {
    var valueAfterAnimation: AnyObject {
        return 0
    }
}

extension CABasicAnimation: CAPropertyAnimationPotocol {
    override var valueAfterAnimation: AnyObject {
        return toValue
    }
}

extension CAKeyframeAnimation: CAPropertyAnimationPotocol {
    override var valueAfterAnimation: AnyObject {
        return values.last!
    }
}

// Task

public class Task {

    var layer: CALayer?
    var animation: CAPropertyAnimation?

    // public property
    public var delay: NSTimeInterval = 0 // animation start after delay time
    public var completion: () -> () = {} // block called when animation is finished

    weak var delegate: Animator?
    var finished = false

    public init(layer: CALayer, animation: CAPropertyAnimation) {
        self.layer = layer
        self.animation = animation
    }

    public init (delay: NSTimeInterval, completion: () -> ()) {
        self.delay = delay
        self.completion = completion
    }

    func start() {
        animation?.delegate = self
        if delay == 0 {
            _start()
            return
        }

        let after = delay * Double(NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(after)), dispatch_get_main_queue()) {
            self._start()
        }
    }

    private func _start() {
        if let layer = layer, let animation = animation {
            layer.addAnimation(animation, forKey: animation.keyPath.hash.description)
            layer.setValue(animation.valueAfterAnimation, forKeyPath: animation.keyPath)
        } else {
            finish()
        }
    }

    dynamic func animationDidStop(_: CAAnimation, finished: Bool) {
        if !finished {
            return
        }

        finish()
    }

    func finish() {
        finished = true
        delegate?.taskDidLoad(self)
        completion()
    }
}

class Animator {

    var duration: NSTimeInterval {

        // find most time at finishing task
        var duration: NSTimeInterval = 0
        for task in tasks {
            var _duration: NSTimeInterval = {
                if let animation = task.animation {
                    return task.delay + animation.duration
                }

                return task.delay
            }()

            if duration < _duration {
                duration = _duration
            }
        }

        return duration
    }

    var tasks = [Task]()
    var completion: () -> () = {}
    var running: Bool {
        for task in tasks {
            if !task.finished {
                return true
            }
        }

        return false
    }

    func start() {
        if !running {
            finish()
        }

        for task in tasks {
            task.delegate = self
            task.start()
        }
    }

    func taskDidLoad(_: Task) {
        if !running {
            finish()
        }
    }

    func finish() {
        completion()
    }
}

class Manager: NSObject {

    var duration: NSTimeInterval {
        return before.duration + present.duration
    }

    let before = Animator()
    let present = Animator()

    override init()  {
    }

    func start(context: UIViewControllerContextTransitioning) {
        if duration == 0.0 {
            setup(context)
        }
        _startBefore(context)
    }
}

extension Manager: UIViewControllerAnimatedTransitioning {

    func animateTransition(context: UIViewControllerContextTransitioning) {
        start(context)
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
}

extension Manager {

    // MARK: setup tasks before running

    private func setup(context: UIViewControllerContextTransitioning) {
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)

        if let fromViewController = fromViewController, let toViewController = toViewController {
            _setupTasks(fromViewController: fromViewController, toViewController: toViewController)
        }
    }

    private func findViewControllerIn(viewController: UIViewController) -> UIViewController {

        switch viewController {
        case let navigationController as UINavigationController:
            return navigationController.topViewController
        default:
            break
        }

        return viewController
    }

    private func _setupTasks(#fromViewController: UIViewController, toViewController: UIViewController) {
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

    private func _startBefore(context: UIViewControllerContextTransitioning) {
        before.completion = {
            self._startPresent(context)
        }

        before.start()
    }

    private func _startPresent(context: UIViewControllerContextTransitioning) {
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
}

public func animate() -> UIViewControllerAnimatedTransitioning? {
    return Manager()
}