//
//  LocationInitializer.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/2/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import RxSwift

final class LocationInitializer: Initializer {
  var locationService: LocationServiceProtocol?

  init(_ locationService: LocationServiceProtocol?) {
    self.locationService = locationService
  }

  func initialize() {
    _ = self.locationService?
      .permissionRequest(targetLevel: .whenInUse)
      .subscribe(onNext: { level in
        print(level)
      }, onError: { error in
        print(error)
      })
  }
}
