//
//  Injector.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import Swinject

final class Injector {
  
  static let instance = Injector()

  var assembler = Assembler(
    [
      ServiceAssembly(),
      TrackingAssembly()
    ])

  static func setupWith(_ assembler: Assembler) {
    Injector.instance.assembler = assembler
  }

  static var resolver: Resolver {
    return Injector.instance.assembler.resolver
  }
}

