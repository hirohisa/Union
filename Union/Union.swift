//
//  Union.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 2/19/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public enum Error: ErrorType {
    case AnimationPreviousNotIncludedInAnimations
}

public protocol Delegate {
    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation]
    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation]
}

extension Delegate {

    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation] {
        return []
    }
    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation] {
        return []
    }
}