//
//  Navigator.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 10/7/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class Navigator: NSObject {

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
        return Navigator()
    }
}

extension Navigator: UIViewControllerAnimatedTransitioning {

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext)
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

extension Navigator {

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

        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey), let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
            toView.frame = fromView.frame
            transitionContext.containerView()?.insertSubview(toView, aboveSubview: fromView)
        }

        present.completion = {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            fromView?.removeFromSuperview()
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