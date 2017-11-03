//
//  TrackingAssembly.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import SwinjectStoryboard
import Swinject

final class TrackingAssembly: Assembly {
  func assemble(container: Container) {
    container.register(TrackingReactor.self) { resolver in
      TrackingReactor(locationService: resolver.resolve(LocationServiceProtocol.self)!)
    }

    container.storyboardInitCompleted(TrackingViewController.self) { resolver, controller in
      controller.reactor = resolver.resolve(TrackingReactor.self)
    }
  }
}
