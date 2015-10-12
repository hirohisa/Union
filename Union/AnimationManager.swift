//
//  AnimationManager.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 5/31/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

class AnimationManager {

    var duration: NSTimeInterval {
        if let animation = animations.sort({$0.duration < $1.duration}).last {
            return animation.duration
        }
        return 0
    }

    var animations = [Animation]()
    typealias CompletionHandler = () -> Void
    var completion: CompletionHandler?
    var running: Bool {
        let result = animations.filter({ !$0.finished })
        return !result.isEmpty
    }

    func start() {
        if !running {
            finish()
        }

        startAnimations(animations.filter({ $0.previous == nil }))
    }

    func startAnimations(animations: [Animation]) {
        for animation in animations {
            animation.delegate = self
            animation.start()
        }
    }

    func animationDidLoad(animation: Animation) {
        let result = animations.filter { $0.previous == animation }
        startAnimations(result)

        if !running {
            finish()
        }
    }

    func finish() {
        completion?()
    }
}
