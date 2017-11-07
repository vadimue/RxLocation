//
//  TrackingAlgorithm.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/6/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol TrackingAlgorithm {
  func track() -> Observable<CLLocation>
}
