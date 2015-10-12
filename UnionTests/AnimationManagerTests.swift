//
//  AnimationManagerTests.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 10/12/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import XCTest
@testable import Union

class AnimationManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAnimationManagerDuration() {
        let manager = AnimationManager()

        manager.animations = [Animation.generate(1)]
        XCTAssertEqual(manager.duration, 1, "result of duration is failed")

        manager.animations = [Animation.generate(1), Animation.generate(2), Animation.generate(3)]
        XCTAssertEqual(manager.duration, 3, "result of duration is failed")
    }

    func testAnimationManagerDurationDelay() {
        let manager = AnimationManager()

        let animation1 = Animation.generate(1)
        animation1.delay = 2
        manager.animations = [animation1]
        XCTAssertEqual(manager.duration, 3, "result of duration is failed")

        let animation2 = Animation.generate(1)
        animation2.delay = 4
        manager.animations = [animation2, Animation.generate(1), Animation.generate(2), Animation.generate(3)]
        XCTAssertEqual(manager.duration, 5, "result of duration is failed")
    }

    func testStateWhenAnimationManagerStart() {
        let manager = AnimationManager()
        manager.animations = [Animation.generate(1)]
        XCTAssertEqual(manager.state, State.Ready, "result of state is failed")
        manager.start()
        XCTAssertEqual(manager.state, State.Animating, "result of state is failed")
    }

    func testStateWhenAnimationManagerStartWithDelay() {
        let expectation = expectationWithDescription("testStateWhenAnimationManagerStartWithDelay")

        let manager = AnimationManager()
        manager.completion = { _ in
            expectation.fulfill()
        }

        let animation1 = Animation.generate(1)
        animation1.delay = 2
        manager.animations = [animation1]
        manager.start()
        XCTAssertEqual(manager.state, State.Animating, "result of state is failed")

        waitForExpectationsWithTimeout(4) { _ in
            XCTAssertEqual(manager.state, State.Finished, "result of state is failed")
        }
    }

    func testAnimationContextsWhenAnimationManagerStart() {
        let manager = AnimationManager()

        let animation0 = Animation.generate(1)
        let animation1 = Animation.generate(1)
        animation1.delay = 2
        let animation2 = Animation.generate(1)
        animation2.previous = animation1
        manager.animations = [animation0, animation1, animation2]

        manager.start()
        XCTAssertEqual(manager.state, State.Animating, "result of state is failed")

        let animatingAnimations = manager.animations.filter({ $0.state == .Animating})
        XCTAssertEqual(animatingAnimations, [animation0], "result of animating animations is failed")

        let waitingAnimations = manager.animations.filter({ $0.state == .Waiting})
        XCTAssertEqual(waitingAnimations, [animation1], "result of waiting animations is failed")

        let readyAnimations = manager.animations.filter({ $0.state == .Ready})
        XCTAssertEqual(readyAnimations, [animation2], "result of waiting animations is failed")
    }

    func testThrowWhenAnimationHasPreviousButAnimationManagerNotHave() {
        let manager = AnimationManager()

        let animation1 = Animation.generate(1)
        animation1.delay = 2
        let animation2 = Animation.generate(1)
        animation2.previous = animation1
        manager.animations = [animation2]

        do {
            try manager.validate()
        } catch Error.AnimationPreviousNotIncludedInAnimations {
        } catch {
            XCTAssertNil(error, "unknown error exists")
        }
    }
}
