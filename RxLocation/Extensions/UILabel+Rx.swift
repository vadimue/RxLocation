//
//  UILabel+Rx.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/1/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
  public var backgroundColor: Binder<UIColor> {
    return Binder(self.base) { label, backgroundColor in
      label.backgroundColor = backgroundColor
    }
  }
}
