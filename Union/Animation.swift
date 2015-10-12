//
//  Animation.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 5/31/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

public enum State {
    case Ready
    case Waiting
    case Animating
    case Finished
}

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

    let layer: CALayer?
    let animation: CAPropertyAnimation?

    typealias AnimationClosure = () -> Void
    let animations: AnimationClosure?

    public var delay: NSTimeInterval = 0
    public typealias CompletionHandler = (Bool) -> Void
    public var completion: CompletionHandler?
    public weak var previous: Animation?

    public var duration: NSTimeInterval {
        var duration = delay + (animation != nil ? animation!.duration : _duration)
        duration += previous?.duration ?? 0
        return duration
    }
    var _duration: NSTimeInterval = 0

    public init(layer: CALayer, animation: CAPropertyAnimation) {
        self.layer = layer
        self.animation = animation
        animations = nil
    }

    public init(duration: NSTimeInterval, animations: () -> Void) {
        layer = nil
        animation = nil
        self.animations = animations

        _duration = duration
    }

    weak var delegate: AnimationManager?
    public var state: State = .Ready
}

extension Animation {

    func start() {
        let block: () -> Void = {
            if self.layer == nil && self.animations == nil {
                self.finish()
                return
            }


            self.state = .Animating
            if let layer = self.layer, let animation = self.animation {
                self._startLayerAnimation(layer, animation)
            }
            if let animations = self.animations {
                self._startAnimationClosure(animations)
            }
        }

        state = .Waiting
        if delay == 0 {
            block()
            return
        }
        let after = delay * Double(NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(after)), dispatch_get_main_queue(), block)
    }

    private func _startLayerAnimation(layer: CALayer, _ animation: CAPropertyAnimation) {
        animation.delegate = self
        layer.addAnimation(animation, forKey: animation.keyPath!.hash.description)
        layer.setValue(animation.valueAfterAnimation, forKeyPath: animation.keyPath!)
    }

    private func _startAnimationClosure(animations: AnimationClosure) {
        UIView.animateWithDuration(_duration, animations: animations) { _ in
            self.finish()
        }
    }

    dynamic func animationDidStop(_: CAAnimation, finished: Bool) {
        finish()
    }

    func finish() {
        state = .Finished
        delegate?.animationDidLoad(self)
        completion?(true)
    }
}

extension Animation: Hashable {

    public var hashValue: Int {
        let pointer = unsafeAddressOf(self)
        return pointer.hashValue
    }
}

public func ==(lhs: Animation, rhs: Animation) -> Bool {
    return lhs.hashValue == rhs.hashValue
}