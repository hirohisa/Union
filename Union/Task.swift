//
//  Task.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 5/31/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

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
    public var dependencies = [Task]()

    // public property
    public var delay: NSTimeInterval = 0 // animation start after delay time
    public var completion: () -> () = {} // block called when animation is finished

    weak var delegate: Animator?
    var finished = false

    public var duration: NSTimeInterval {
        var duration: NSTimeInterval = {
            if let animation = self.animation {
                return self.delay + animation.duration
            }

            return self.delay
            }()

        for task in dependencies {
            let _duration: NSTimeInterval = self.delay + task.duration
            if duration < _duration {
                duration = _duration
            }
        }

        return duration
    }

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

        for task in dependencies {
            task.start()
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