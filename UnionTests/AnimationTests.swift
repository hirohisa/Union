//
//  AnimationTests.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 6/3/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import XCTest

@testable import Union

extension Animation {

    class func generate(duration: NSTimeInterval) -> Animation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: CGPointZero)
        animation.toValue = NSValue(CGPoint: CGPointZero)
        animation.duration = duration
        return Animation(layer: CALayer(), animation: animation)
    }
}

class AnimationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAnimationDuration() {
        let animation = Animation.generate(1)
        XCTAssertEqual(animation.duration, 1, "result of duration is failed")
    }

    func testAnimationDurationDelay() {
        let animation = Animation.generate(1)
        XCTAssertEqual(animation.duration, 1, "result of duration is failed")

        animation.delay = 2
        XCTAssertEqual(animation.duration, 3, "result of duration is failed")
    }

    func testAnimationDurationDependency() {
        let animation = Animation.generate(1)
        XCTAssertEqual(animation.duration, 1, "result of duration is failed")

        animation.delay = 2
        XCTAssertEqual(animation.duration, 3, "result of duration is failed")

        let parentAnimation = Animation.generate(1)
        animation.previous = parentAnimation
        XCTAssertEqual(animation.duration, 4, "result of duration is failed")

        parentAnimation.delay = 1
        XCTAssertEqual(animation.duration, 5, "result of duration is failed")
    }

    func testAnimationFinishedAfterAnimating() {
        let expectation = expectationWithDescription("testAnimationFinishedAfterAnimating")

        let animation = Animation.generate(1)
        animation.start()
        animation.completion = { _ in
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1.1) { _ in
            XCTAssertEqual(animation.state, State.Finished, "result of state is failed")
        }
    }

}
