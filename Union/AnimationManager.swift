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
        var duration: NSTimeInterval = 0
        for animation in animations {
            if duration < animation.duration {
                duration = animation.duration
            }
        }

        return duration
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
