//
//  TrackingViewControllerTests.swift
//  RxLocationTests
//
//  Created by Vadym Brusko on 11/9/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

@testable import RxLocation
import CoreLocation
import XCTest
import RxSwift
import Foundation
import UIKit

class TrackingViewControllerTests: XCTestCase {

  var view: TrackingViewController!
  var reactor: TrackingReactor!

  override func setUp() {
    reactor = TrackingReactor(trackingService: MockTrackingService(),
                              locationService: MockLocationService())
    reactor.stub.isEnabled = true

    let storyboard: UIStoryboard = UIStoryboard(name: "Tracking", bundle: nil)
    view = storyboard.instantiateViewController(withIdentifier: "TrackingViewController") as! TrackingViewController
    view.reactor = reactor
    _ = view.view
  }

  func test_bind_autoTrackingSwitched_fireToggleAutoTracking() {
    // arrange

    // act
    view.autoTrackingSwitch.sendActions(for: .valueChanged)

    // assert
    XCTAssertEqual(reactor.stub.actions.last!, TrackingReactor.Action.toggleAutoTracking(true))
  }

}

extension TrackingReactor.Action: Equatable {
  public static func ==(lhs: TrackingReactor.Action, rhs: TrackingReactor.Action) -> Bool {
    switch (lhs, rhs) {
    case (let .toggleAutoTracking(l), let .toggleAutoTracking(r)):
      return l == r
    case (.tranferCurrentPosition, .tranferCurrentPosition):
      return true
    default:
      return false
    }
  }
}

