//
//  TrackingAssembly.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

final class TrackingAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(TrackingReactor.self, initializer: TrackingReactor.init)

    container.storyboardInitCompleted(TrackingViewController.self) { resolver, controller in
      controller.reactor = resolver.resolve(TrackingReactor.self)
    }
  }
}
