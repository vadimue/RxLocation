//
//  TrackingViewController.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/1/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class TrackingViewController: UIViewController, StoryboardView {
  var disposeBag = DisposeBag()

  @IBOutlet weak var autoTrackingLabel: UILabel!
  @IBOutlet weak var autoTrackingSwitch: UISwitch!
  @IBOutlet weak var activePositionLabel: UILabel!
  @IBOutlet weak var lastPositionLabel: UILabel!
  @IBOutlet weak var lastTimeLabel: UILabel!
  @IBOutlet weak var transferPositionButton: UIButton!

  func bind(reactor: TrackingReactor) {

    // State
    let isAutoTrackingActive = reactor.state.asObservable()
      .map { $0.isAutoTrackingActive }.distinctUntilChanged()

    isAutoTrackingActive
      .bind(to: autoTrackingSwitch.rx.value)
      .disposed(by: disposeBag)

    isAutoTrackingActive.map { $0 ? "Auto-Tracking active" : "Auto-Tracking inactive" }
      .bind(to: autoTrackingLabel.rx.text)
      .disposed(by: disposeBag)

    isAutoTrackingActive.map { $0 ? UIColor.green : UIColor.red }
      .bind(to: autoTrackingLabel.rx.backgroundColor)
      .disposed(by: disposeBag)

    reactor.state.asObservable()
      .map { $0.activePosition }
      .bind(to: activePositionLabel.rx.locationText)
      .disposed(by: disposeBag)

    reactor.state.asObservable()
      .map { $0.lastPosition }
      .bind(to: lastPositionLabel.rx.locationText)
      .disposed(by: disposeBag)

    reactor.state.asObservable()
      .map { $0.lastPosition.timestamp }
      .bind(to: lastTimeLabel.rx.timeText)
      .disposed(by: disposeBag)

    // Action
    autoTrackingSwitch.rx.value
      .map(Reactor.Action.toggleAutoTracking)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    transferPositionButton.rx.tap
      .map { Reactor.Action.tranferCurrentPosition }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

