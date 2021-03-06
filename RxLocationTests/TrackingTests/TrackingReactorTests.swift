//
//  TrackingReactorTests.swift
//  RxLocationTests
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

@testable import RxLocation
import CoreLocation
import XCTest

class TrackingReactorTests: XCTestCase {

  var reactor: TrackingReactor!
  var trackingService: MockTrackingService!
  var locationServive: MockLocationService!

  override func setUp() {
    trackingService = MockTrackingService()
    locationServive = MockLocationService()
    reactor = TrackingReactor(trackingService: trackingService, locationService: locationServive)
  }

  func test_reduce_toggleAutoTrackingTrue_changeAutoTrackingState() {
    // arrange
    _ = reactor.state

    // act
    reactor.action.onNext(.toggleAutoTracking(true))

    // assert
    XCTAssert(reactor.currentState.isAutoTrackingActive)
  }

  func test_reduce_toggleAutoTrackingFalse_changeAutoTrackingState() {
    // arrange
    _ = reactor.state

    // act
    reactor.action.onNext(.toggleAutoTracking(false))

    // assert
    XCTAssertFalse(reactor.currentState.isAutoTrackingActive)
  }

  func test_transformMutation_emitActiveTransmition_changePositionState() {
    // arrange
    let location = CLLocation(latitude: 1.01, longitude: 2.02)
    trackingService.trackReturnValue = .just(location)

    // act
    _ = reactor.state
    reactor.action.onNext(.toggleAutoTracking(true))

    // assert
    XCTAssertEqual(reactor.currentState.activePosition, location)
    XCTAssertEqual(reactor.currentState.lastPosition, reactor.initialState.activePosition)
  }

}
