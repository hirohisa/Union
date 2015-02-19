//
//  Union.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 2015/02/19.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import QuartzCore

@objc
public protocol Delegate {
    optional func tasksBeforeTransition(operation: UINavigationControllerOperation) -> [Task]
    optional func tasksDuringTransition(operation: UINavigationControllerOperation) -> [Task]
}

public class Task {
    let layer: CALayer?
    let animation: CABasicAnimation?

    // public property
    public var delay: NSTimeInterval = 0.0
    public var completion: () -> () = {}

    var delegate: Animator?
    var finished: Bool = false

    public init(layer: CALayer, animation: CABasicAnimation) {
        self.layer = layer
        self.animation = animation
    }

    public init (delay: NSTimeInterval, completion: () -> ()) {
        self.delay = delay
        self.completion = completion
    }

    func start() {
        self.animation?.delegate = self
        if delay == 0.0 {
            _start()
            return
        }

        let after = delay * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(after))
        dispatch_after(time, dispatch_get_main_queue(), {
            self._start()
        })
    }

    func _start() {
        if let _layer = layer {
            _layer.addAnimation(animation, forKey: animation!.keyPath.hash.description)
            if let toValue: AnyObject = animation!.toValue {
                _layer.setValue(toValue, forKeyPath: animation!.keyPath)
            }
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
        self.finished = true
        delegate?.taskDidLoad(self)
        completion()
    }
}

class Animator {
    var duration: NSTimeInterval {

        var duration = 0.0
        for task: Task in tasks {
            var d: NSTimeInterval = {
                if let animation = task.animation {
                    return task.delay + animation.duration
                }

                return task.delay
            }()

            if duration < d {
                duration = d
            }
        }

        return duration
    }
    var tasks: [Task] = [Task]()
    var completion: () -> () = {}
    var running: Bool {
        for task: Task in tasks {
            if !task.finished {
                return true
            }
        }

        return false
    }

    init() {
    }

    func start() {
        if !self.running {
            finish()
        }

        for task: Task in tasks {
            task.delegate = self
            task.start()
        }
    }

    func taskDidLoad(_: Task) {
        if !self.running {
            finish()
        }
    }

    func finish() {
        completion()
    }
}

class Manager: NSObject {

    let operation: UINavigationControllerOperation
    var duration: NSTimeInterval {
        return self.before.duration + self.present.duration
    }

    let before: Animator = Animator()
    let present: Animator = Animator()

    init(operation: UINavigationControllerOperation)  {
        self.operation = operation
    }

    func start(context: UIViewControllerContextTransitioning) {
        if duration == 0.0 {
            setup(context)
        }
        _startBefore(context)
    }

    func _startBefore(context: UIViewControllerContextTransitioning) {
        before.completion = {
            self._startPresent(context)
        }

        before.start()
    }

    func _startPresent(context: UIViewControllerContextTransitioning) {
        let frame = context.finalFrameForViewController(context.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        let fromView = context.viewForKey(UITransitionContextFromViewKey)!
        let toView = context.viewForKey(UITransitionContextToViewKey)!
        toView.frame = frame
        context.containerView().insertSubview(toView, aboveSubview: fromView)

        present.completion = {
            fromView.removeFromSuperview()
            context.completeTransition(true)
        }
        present.start()
    }
}

extension Manager {
    func setup(context: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC: UIViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)!

        _setupTasks(fromVC: fromVC as? Delegate, toVC: toVC as? Delegate)
    }

    func _setupTasks(#fromVC: Delegate?, toVC: Delegate?) {
        // before
        if let tasks = fromVC?.tasksBeforeTransition?(operation) {
            before.tasks = tasks
        }

        // present
        var tasks: [Task] = [Task]()
        if let ts = fromVC?.tasksDuringTransition?(operation) {
            tasks += ts
        }
        if let ts = toVC?.tasksDuringTransition?(operation) {
            tasks += ts
        }

        present.tasks = tasks
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

public func transition(operation: UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning {
    return Manager(operation: operation)
}