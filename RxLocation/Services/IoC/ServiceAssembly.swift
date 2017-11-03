//
//  ServiceAssembly.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import Swinject
import CoreLocation

final class ServiceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(LocationServiceProtocol.self, factory: { _ in
      LocationService {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
      }
    }).inObjectScope(.container)
  }
}
