//
//  MockTrackingService.swift
//  RxLocationTests
//
//  Created by Vadym Brusko on 11/7/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

@testable import RxLocation
import Foundation
import CoreLocation
import RxSwift

class MockTrackingService: TrackingAlgorithm {

  var trackCalled = false
  var trackReturnValue: Observable<CLLocation>! = .empty()

  public func track() -> Observable<CLLocation> {
    trackCalled = true
    return trackReturnValue
  }
}

