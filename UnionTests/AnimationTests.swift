//
//  AnimationTests.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 6/3/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
import Union


class AnimationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDuration() {

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: CGPointZero)
        animation.toValue = NSValue(CGPoint: CGPointZero)
        animation.duration = 1

        let mainAnimation = Animation(layer: CALayer(), animation: animation)
        XCTAssertEqual(mainAnimation.duration, 1, "result of duration is failed") // 1(animation.duration)

        mainAnimation.delay = 2
        XCTAssertEqual(mainAnimation.duration, 3, "result of duration is failed") // 2(animation.delay) + 1(animation.duration)

        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.fromValue = NSValue(CGPoint: CGPointZero)
        animation2.toValue = NSValue(CGPoint: CGPointZero)
        animation2.duration = 3
        let subAnimation1 = Animation(layer: CALayer(), animation: animation2)
        mainAnimation.dependencies = [subAnimation1]
        XCTAssertEqual(mainAnimation.duration, 5, "result of duration is failed") // 2(animation.delay) + 3(subAnimation1.duration)

        subAnimation1.delay = 2
        XCTAssertEqual(mainAnimation.duration, 7, "result of duration is failed") // 2(animation.delay) + 2(subAnimation1.delay) + 3(subAnimation1.duration)

        let subAnimation2 = Animation(layer: CALayer(), animation: animation)
        subAnimation2.delay = 5
        mainAnimation.dependencies = [subAnimation1, subAnimation2]
        XCTAssertEqual(mainAnimation.duration, 8, "result of duration is failed") // 2(animation.delay) + 5(subAnimation2.delay) + 1(subAnimation2.duration)

        let subAnimation3 = Animation(layer: CALayer(), animation: animation2)
        subAnimation3.delay = 5
        subAnimation1.dependencies = [subAnimation3]
        XCTAssertEqual(mainAnimation.duration, 12, "result of duration is failed") // 2(animation.delay) + 2(subAnimation1.delay) + 5(subAnimation3.delay) + 3(subAnimation3.duration)
    }

}
