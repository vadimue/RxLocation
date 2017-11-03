//
//  AppDelegate.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/1/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import UIKit
import CoreLocation
import SwinjectStoryboard

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    initialize()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window

    let storyboard = SwinjectStoryboard.create(name: "Tracking", bundle: nil, container: Injector.resolver)
    window.rootViewController = storyboard.instantiateInitialViewController()

    return true
  }
}

// MARK: Initializers

extension AppDelegate: Initializer {
  var initializers: [Initializer] {
    let resolver = Injector.resolver
    return [
      LocationInitializer(resolver.resolve(LocationServiceProtocol.self))
    ]
  }

  func initialize() {
    for initializer in self.initializers {
      initializer.initialize()
    }
  }
}

