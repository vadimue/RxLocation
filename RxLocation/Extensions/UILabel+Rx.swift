//
//  UILabel+Rx.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/2/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

extension Reactive where Base: UILabel {
  public var locationText: Binder<CLLocation> {
    return Binder(self.base) { label, location in
      label.text = "x:\(location.coordinate.latitude), y:\(location.coordinate.longitude)"
    }
  }

  public var timeText: Binder<Date> {
    return Binder(self.base) { label, date in
      let dateFormatterGet = DateFormatter()
      dateFormatterGet.dateFormat = "dd.MM.yyyy hh:mm:ss"
      let stringDate = dateFormatterGet.string(from: date)
      label.text = stringDate
    }
  }
}
