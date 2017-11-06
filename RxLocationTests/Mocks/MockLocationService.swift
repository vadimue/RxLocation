//
//  MockLocationService.swift
//  RxLocationTests
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

@testable import RxLocation
import Foundation
import CoreLocation
import RxSwift

class MockLocationService: LocationServiceProtocol {

  var locationCalled = false
  var locationReceivedArguments: (LocationManagerConfigurator?)?
  var locationReturnValue: Observable<CLLocation>! = .empty()

  public func location(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    locationCalled = true
    locationReceivedArguments = managerFactory
    return locationReturnValue
  }

  var singleLocationCalled = false
  var singleLocationReceivedArguments: (LocationManagerConfigurator?)?
  var singleLocationReturnValue: Observable<CLLocation>! = .empty()

  public func singleLocation(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    singleLocationCalled = true
    singleLocationReceivedArguments = managerFactory
    return singleLocationReturnValue
  }

  var permissionRequestCalled = false
  var permissionRequestReceivedArguments: (targetLevel: LocationAuthorizationLevel, managerFactory: LocationManagerConfigurator?)?
  var permissionRequestReturnValue: Observable<LocationAuthorizationLevel>! = .empty()

  public func permissionRequest(targetLevel: LocationAuthorizationLevel,
                                _ managerFactory: LocationManagerConfigurator? = nil)
    -> Observable<LocationAuthorizationLevel> {
      permissionRequestCalled = true
      permissionRequestReceivedArguments = (targetLevel: targetLevel, managerFactory: managerFactory)
      return permissionRequestReturnValue
  }
}
