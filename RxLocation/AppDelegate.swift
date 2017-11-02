//
//  AppDelegate.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/1/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import UIKit
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    initialize()
    return true
  }
}

// MARK: Initializers

extension AppDelegate: Initializer {
  var initializers: [Initializer] {
    return [
      LocationInitializer(LocationService {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
      })
    ]
  }

  func initialize() {
    for initializer in self.initializers {
      initializer.initialize()
    }
  }
}

