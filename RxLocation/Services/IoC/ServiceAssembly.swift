//
//  ServiceAssembly.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import CoreLocation

final class ServiceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(LocationServiceProtocol.self, factory: { _ in
      LocationService {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.allowsBackgroundLocationUpdates = true
        return manager
      }
    }).inObjectScope(.container)
    container.autoregister(TrackingAlgorithm.self, initializer: TrackingService.init)
    container.register(SchedulerType.self) { _ in SerialDispatchQueueScheduler(qos: .default) }
  }
}
