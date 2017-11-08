//
//  TrackingService.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/6/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class TrackingService: TrackingAlgorithm {

  let repeatingTimePeriod: Double = 60
  let mindlessDistanceInMeters: Double = 10

  let locationService: LocationServiceProtocol
  let timerScheduler: SchedulerType

  init(locationService: LocationServiceProtocol, timerScheduler: SchedulerType) {
    self.locationService = locationService
    self.timerScheduler = timerScheduler
  }

  func track() -> Observable<CLLocation> {
    let location = self.locationService.location()
      .do(onNext: { self.log($0, "update: ") })
      .share(replay: 1, scope: SubjectLifetimeScope.forever)

    let firstLocation = location.take(1)

    let locationChangedMoreThan10Meters =
      Observable.zip(location, location.skip(1)) { (previous: $0, current: $1) }
        .filter { $0.current.distance(from: $0.previous) > self.mindlessDistanceInMeters }
        .map { $0.current }

    let validLocations = Observable.of(firstLocation,locationChangedMoreThan10Meters).merge()

    let oncePerMinuteLocation = validLocations
        .flatMapLatest { [weak self] _ -> Observable<CLLocation> in
          guard let `self` = self else { return .empty() }
          return Observable<Int>.interval(self.repeatingTimePeriod, scheduler: self.timerScheduler)
            .withLatestFrom(location)
    }
    
    return Observable.of(validLocations, oncePerMinuteLocation).merge()
  }

  private func repeatLastLocationEveryMinute(_ lastLocation: Observable<CLLocation>) -> Observable<CLLocation> {
    return Observable<Int>.interval(repeatingTimePeriod, scheduler: timerScheduler)
      .withLatestFrom(lastLocation)
  }

  private func log(_ location: CLLocation, _ log: String = "") {
    print(log + "\(location.coordinate.latitude), \(location.coordinate.longitude) time: \(location.timestamp)")
  }
}
