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
      .share(replay: 1, scope: SubjectLifetimeScope.forever)
      .do(onNext: { self.log($0, "update: ") })

    let firstLocation = location.take(1)

    let locationChangedMoreThan10Meters =
      Observable.zip(location, location.skip(1)) { (previous: $0, current: $1) }
        //.do(onNext: { print("zip: \($0.current.coordinate.latitude) \($0.current.coordinate.longitude) + \($0.previous.coordinate.latitude) \($0.previous.coordinate.longitude)") })
        .filter {
          let meters = $0.current.distance(from: $0.previous)
          //print("distance in meters: \(meters)")
          return meters > self.mindlessDistanceInMeters
        }
        .map { $0.current }
    //.do(onNext: { self.log($0, "after zip:") })

    let validLocations = Observable.of(firstLocation
      //      .do(onNext: { self.log($0, "finished take first 10: ") })
      ,
      locationChangedMoreThan10Meters
      //                                        .do(onNext: { self.log($0, "finished more than 10: ") })
      )
      .merge()

    let oncePerMinuteLocation =
      validLocations
        .do(onNext: { self.log($0, "per minute with latest from:") })
        .flatMapLatest { [weak self] _ -> Observable<CLLocation> in
          guard let `self` = self else { return .empty() }
          return self.repeatLastLocationEveryMinute(location)
    }
    
    return Observable.of(validLocations,
                         oncePerMinuteLocation
      //                          .do(onNext: { self.log($0, "finished per minute: ") })
      ).merge()
  }

  private func repeatLastLocationEveryMinute(_ lastLocation: Observable<CLLocation>) -> Observable<CLLocation> {
    return Observable<Int>.interval(repeatingTimePeriod, scheduler: timerScheduler)
      .withLatestFrom(lastLocation)
      .do(onNext: { self.log($0, "once per minute location:") })
  }

  private func log(_ location: CLLocation, _ log: String = "") {
    print(log + "\(location.coordinate.latitude), \(location.coordinate.longitude) time: \(location.timestamp)")
  }
}
