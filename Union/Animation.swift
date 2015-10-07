//
//  Animation.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 5/31/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

// Protocol Animation

protocol CAPropertyAnimationPotocol {
    var valueAfterAnimation: AnyObject { get }
    var keyPathOfAnimation: String { get }
}

extension CAPropertyAnimation: CAPropertyAnimationPotocol {
    var valueAfterAnimation: AnyObject {
        return 0
    }
    var keyPathOfAnimation: String {
        return keyPath!
    }
}

extension CABasicAnimation {
    override var valueAfterAnimation: AnyObject {
        return toValue!
    }
}

extension CAKeyframeAnimation {
    override var valueAfterAnimation: AnyObject {
        return values!.last!
    }
}

// Animation

public class Animation {

    var layer: CALayer?
    var animation: CAPropertyAnimation?
    public var dependencies = [Animation]()

    // public property
    public var delay: NSTimeInterval = 0 // animation start after delay time
    public var completion: () -> () = {} // block called when animation is finished

    weak var delegate: AnimationManager?
    var finished = false

    public var duration: NSTimeInterval {
        var duration: NSTimeInterval = {
            if let animation = self.animation {
                return self.delay + animation.duration
            }

            return self.delay
            }()

        for animation in dependencies {
            let _duration: NSTimeInterval = self.delay + animation.duration
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
            layer.addAnimation(animation, forKey: animation.keyPath!.hash.description)
            layer.setValue(animation.valueAfterAnimation, forKeyPath: animation.keyPath!)
        } else {
            finish()
        }

        for animation in dependencies {
            animation.start()
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
        delegate?.animationDidLoad(self)
        completion()
    }
}