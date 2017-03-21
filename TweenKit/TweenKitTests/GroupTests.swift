//
//  GroupTests.swift
//  TweenKit
//
//  Created by Steven Barnegren on 20/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

class GroupTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = Scheduler()
    }
    
    func testGroupHasExpectedDuration() {
        
        let oneSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, update: { _ in })
        let twoSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, update: { _ in })
        let threeSecondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, update: { _ in })
        
        let group = Group(actions: oneSecondAction, twoSecondAction, threeSecondAction)
        XCTAssertEqualWithAccuracy(group.duration, 3.0, accuracy: 0.001)
    }
    
    func testAllActionsComplete() {
        
        var firstValue = 0.0
        var secondValue = 0.0
        var thirdValue = 0.0
        
        let firstAction = InterpolationAction(from: 0.0, to: 1.0, duration: 1.0, update: { firstValue = $0 })
        let secondAction = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, update: { secondValue = $0 })
        let thirdAction = InterpolationAction(from: 0.0, to: 1.0, duration: 3.0, update: { thirdValue = $0 })
        
        let group = Group(actions: firstAction, secondAction, thirdAction)
        let animation = Animation(action: group)
        scheduler.add(animation: animation)
        scheduler.stepTime(duration: group.duration + 1)
        
        XCTAssertEqualWithAccuracy(firstValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(secondValue, 1.0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(thirdValue, 1.0, accuracy: 0.001)
    }
    
    func testRunBlockActionsAreRunAtBeginning() {
        
        var wasInvoked = false
        
        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = Group(actions: interpolate, runBlock)
        group.willBecomeActive()
        
        XCTAssertTrue(wasInvoked)
    }
    
    func testRunBlockActionsAreNotRunAtEnd() {
        
        var wasInvoked = false
        
        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = Group(actions: interpolate, runBlock)
        group.didBecomeInactive()
        
        XCTAssertFalse(wasInvoked)
    }
    
    func testRunBlockActionAreRunAtEndInReverse() {
        
        var wasInvoked = false

        let interpolate = InterpolationAction(from: 0.0, to: 1.0, duration: 5.0, update: { _ in })
        let runBlock = RunBlockAction{
            wasInvoked = true
        }
        let group = Group(actions: interpolate, runBlock)
        group.willBecomeActive()
        
        XCTAssertTrue(wasInvoked)
    }
    
    
    
}