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
    func animationsBeforeTransition(from fromViewController: UIViewController, to toViewController: UIViewController) -> [Animation]
    func animationsDuringTransition(from fromViewController: UIViewController, to toViewController: UIViewController) -> [Animation]
}

extension Delegate {

    func animationsBeforeTransition(from fromViewController: UIViewController, to toViewController: UIViewController) -> [Animation] {
        return []
    }
    func animationsDuringTransition(from fromViewController: UIViewController, to toViewController: UIViewController) -> [Animation] {
        return []
    }
}