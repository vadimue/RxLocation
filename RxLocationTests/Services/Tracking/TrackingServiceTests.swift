//
//  TrackingServiceTests.swift
//  RxLocationTests
//
//  Created by Vadym Brusko on 11/6/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

@testable import RxLocation
import XCTest
import RxTest
import RxSwift
import CoreLocation

class TrackingServiceTests: XCTestCase {

  let someLocation = CLLocation(latitude: 1.00000001, longitude: 2.00000002)

  var service: TrackingAlgorithm!
  var locationService: MockLocationService!
  var scheduler: TestScheduler!
  
  override func setUp() {
    locationService = MockLocationService()
    scheduler = TestScheduler(initialClock: 0)
    service = TrackingService(locationService: locationService, timerScheduler: scheduler)
  }

  func test_track_valueNotUpdate_emitPreviousValueEveryOneMinute() {

    // arrange
    let observable = scheduler.createHotObservable([
      next(0, someLocation)
    ]).asObservable()
    locationService.locationReturnValue = observable

    let results = scheduler.createObserver(CLLocation.self)
    var subscription: Disposable! = nil

    // act
    subscription = self.service.track().subscribe(results)
    scheduler.scheduleAt(finishTime) { subscription.dispose() }
    scheduler.start()

    // assert
    XCTAssertEqual(results.events, [
      next(0, someLocation),
      next(60, someLocation),
      next(120, someLocation),
      next(180, someLocation),
      next(240, someLocation),
      next(300, someLocation),
      next(360, someLocation),
      next(420, someLocation),
      next(480, someLocation),
      next(540, someLocation),
      next(600, someLocation)
    ])
  }

  var finishTime: Int {
    let repeatingTimePeriod = 60
    let countOfRepeating = 10
    return repeatingTimePeriod*countOfRepeating + repeatingTimePeriod/2
  }

  func test_track_positionChangedLessThan10Meters_doesNotEmitNewValue() {
    // arrange
    let location2 = CLLocation(latitude: 10.00000003, longitude: 20.00000005)
    let location3 = CLLocation(latitude: 10.00000004, longitude: 20.00000006)
    let observable = scheduler.createHotObservable([
      next(0, someLocation),
      next(10, location2),
      next(20, location3)
    ]).asObservable()
    locationService.locationReturnValue = observable

    let results = scheduler.createObserver(CLLocation.self)
    var subscription: Disposable! = nil

    // act
    subscription = self.service.track().subscribe(results)
    scheduler.scheduleAt(50) { subscription.dispose() }
    scheduler.start()

    // assert
    XCTAssertEqual(results.events, [
      next(0, someLocation),
      next(10, location2)
    ])
  }

  func test_track_positionChangedMoreThan10Meters_emitNewValue() {
    // arrange
    let location2 = CLLocation(latitude: 10.00000003, longitude: 20.00000005)
    let location3 = CLLocation(latitude: 10.00010000, longitude: 20.00010000)
    let observable = scheduler.createHotObservable([
      next(0, someLocation),
      next(10, location2),
      next(20, location3)
    ]).asObservable()
    locationService.locationReturnValue = observable

    let results = scheduler.createObserver(CLLocation.self)
    var subscription: Disposable! = nil

    // act
    subscription = self.service.track().subscribe(results)
    scheduler.scheduleAt(50) { subscription.dispose() }
    scheduler.start()

    // assert
    XCTAssertEqual(results.events, [
      next(0, someLocation),
      next(10, location2),
      next(20, location3)
    ])
  }

  func test_track_positionChangedLessThan10Meters_emitPreviousValueAfterOneMinute() {
    // arrange
    let location2 = CLLocation(latitude: 1.00000003, longitude: 2.00000005)
    let location3 = CLLocation(latitude: 1.00000004, longitude: 2.00000006)
    let location4 = CLLocation(latitude: 1.00010000, longitude: 2.00010000)
    let location5 = CLLocation(latitude: 1.00010001, longitude: 2.00010002)
    let observable = scheduler.createHotObservable([
      next(0, someLocation),
      next(40, location2),
      next(80, location3),
      next(150, location4),
      next(170, location5),
    ]).asObservable()
    locationService.locationReturnValue = observable

    let results = scheduler.createObserver(CLLocation.self)
    var subscription: Disposable! = nil

    // act
    subscription = self.service.track().subscribe(results)
    scheduler.scheduleAt(220) { subscription.dispose() }
    scheduler.start()

    // assert
    XCTAssertEqual(results.events, [
      next(0, someLocation),
      next(60, location2),
      next(120, location3),
      next(150, location4),
      next(210, location5),
    ])
  }

  func test_track_positionChangedFast_doesNotEmitMoreOftenThanEvery10Seconds() {
    let location2 = CLLocation(latitude: 1.00010000, longitude: 2.00010000)
    let location3 = CLLocation(latitude: 1.00020000, longitude: 2.00020000)
    let location4 = CLLocation(latitude: 1.00030000, longitude: 2.00030000)
    let location5 = CLLocation(latitude: 1.00040000, longitude: 2.00040000)
    let observable = scheduler.createHotObservable([
      next(0, someLocation),
      next(3, location2),
      next(5, location3),
      next(12, location4),
      next(17, location5),
    ]).asObservable()
    locationService.locationReturnValue = observable

    let results = scheduler.createObserver(CLLocation.self)
    var subscription: Disposable! = nil

    // act
    subscription = self.service.track().subscribe(results)
    scheduler.scheduleAt(50) { subscription.dispose() }
    scheduler.start()

    // assert
    XCTAssertEqual(results.events, [
      next(0, someLocation),
      next(10, location3),
      next(20, location5),
    ])
  }

}
