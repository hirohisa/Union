//
//  TaskTests.swift
//  Union
//
//  Created by Hirohisa Kawasaki on 6/3/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
import Union


class TaskTests: XCTestCase {

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

        let task = Task(layer: CALayer(), animation: animation)
        XCTAssertEqual(task.duration, 1, "result of duration is failed") // 1(animation.duration)

        task.delay = 2
        XCTAssertEqual(task.duration, 3, "result of duration is failed") // 2(task.delay) + 1(animation.duration)

        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.fromValue = NSValue(CGPoint: CGPointZero)
        animation2.toValue = NSValue(CGPoint: CGPointZero)
        animation2.duration = 3
        let subTask1 = Task(layer: CALayer(), animation: animation2)
        task.dependencies = [subTask1]
        XCTAssertEqual(task.duration, 5, "result of duration is failed") // 2(task.delay) + 3(subTask1.duration)

        subTask1.delay = 2
        XCTAssertEqual(task.duration, 7, "result of duration is failed") // 2(task.delay) + 2(subTask1.delay) + 3(subTask1.duration)

        let subTask2 = Task(layer: CALayer(), animation: animation)
        subTask2.delay = 5
        task.dependencies = [subTask1, subTask2]
        XCTAssertEqual(task.duration, 8, "result of duration is failed") // 2(task.delay) + 5(subTask2.delay) + 1(subTask2.duration)

        let subTask3 = Task(layer: CALayer(), animation: animation2)
        subTask3.delay = 5
        subTask1.dependencies = [subTask3]
        XCTAssertEqual(task.duration, 12, "result of duration is failed") // 2(task.delay) + 2(subTask1.delay) + 5(subTask3.delay) + 3(subTask3.duration)
    }

}
