//
//  SwinjectStoryboardExtension.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/3/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
  public static func setup() {
    defaultContainer = Injector.resolver as! Container
  }
}
