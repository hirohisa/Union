//
//  Animator.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 5/31/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

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
