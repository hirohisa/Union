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

    var state: State {

        var hasFinishedAnimation = false
        for animation in animations {
            switch animation.state {
            case .Ready:
                break
            case .Waiting, .Animating:
                return .Animating
            case .Finished:
                hasFinishedAnimation = true
                break
            }
        }

        return hasFinishedAnimation ? .Finished: .Ready
    }

    func start() {
        try! validate()
        startAnimations(animations.filter({ $0.previous == nil }))
    }

    func validate() throws {
        let result = animations.flatMap({ $0.previous }).filter({ !animations.contains($0) })
        if  !result.isEmpty {
            throw Error.AnimationPreviousNotIncludedInAnimations
        }
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

        if state == .Finished {
            finish()
        }
    }

    func finish() {
        completion?()
    }
}
