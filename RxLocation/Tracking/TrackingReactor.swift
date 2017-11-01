//
//  TrackingReactor.swift
//  RxLocation
//
//  Created by Vadym Brusko on 11/1/17.
//  Copyright © 2017 Vadim Inc. All rights reserved.
//

import ReactorKit
import CoreLocation
import RxCocoa
import RxSwift

final class TrackingReactor: Reactor {

  enum Action {
    case toggleAutoTracking(Bool)
    case tranferCurrentPosition
  }

  enum Mutation {
    case toggleAutoTracking(Bool)
  }

  struct State {
    var isAutoTrackingActive: Bool
    var activePosition: CLLocation
    var lastPosition: CLLocation
  }

  let initialState: State

  init() {
    initialState = State(isAutoTrackingActive: false, activePosition: CLLocation(), lastPosition: CLLocation())
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleAutoTracking(let enabled):
      return .just(.toggleAutoTracking(enabled))
    case .tranferCurrentPosition:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .toggleAutoTracking(let enabled):
      state.isAutoTrackingActive = enabled
    }
    return state
  }
}
