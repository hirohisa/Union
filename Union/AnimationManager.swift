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
    var completion: () -> () = {}
    var running: Bool {
        for animation in animations {
            if !animation.finished {
                return true
            }
        }

        return false
    }

    func start() {
        if !running {
            finish()
        }

        for animation in animations {
            animation.delegate = self
            animation.start()
        }
    }

    func animationDidLoad(_: Animation) {
        if !running {
            finish()
        }
    }

    func finish() {
        completion()
    }
}
