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
        var duration: NSTimeInterval = 0
        for task in tasks {
            if duration < task.duration {
                duration = task.duration
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
