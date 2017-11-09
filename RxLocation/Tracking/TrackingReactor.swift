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
import RxOptional

final class TrackingReactor: Reactor {

  enum Action {
    case toggleAutoTracking(Bool)
    case tranferCurrentPosition
  }

  enum Mutation {
    case toggleAutoTracking(Bool)
    case updateActivePosition(CLLocation)
  }

  struct State {
    var isAutoTrackingActive: Bool
    var activePosition: CLLocation
    var lastPosition: CLLocation
  }

  let initialState: State

  let trackingService: TrackingAlgorithm
  let locationService: LocationServiceProtocol

  init(trackingService: TrackingAlgorithm, locationService: LocationServiceProtocol) {
    self.trackingService = trackingService
    self.locationService = locationService
    initialState = State(isAutoTrackingActive: true, activePosition: CLLocation(), lastPosition: CLLocation())
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleAutoTracking(let enabled):
      return .just(.toggleAutoTracking(enabled))
    case .tranferCurrentPosition:
      return locationService.singleLocation()
        .map(Mutation.updateActivePosition)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .toggleAutoTracking(let enabled):
      state.isAutoTrackingActive = enabled
    case .updateActivePosition(let activePosition):
      state.lastPosition = state.activePosition
      state.activePosition = activePosition
    }
    return state
  }

  func transform(mutation: Observable<TrackingReactor.Mutation>) -> Observable<Mutation> {
    return .merge(mutation, getActivePosition(mutation))
  }

  private func getActivePosition(_ mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .map { mutation -> Bool? in
        switch mutation {
        case .toggleAutoTracking(let isActive):
          return isActive
        default:
          return nil
        }
      }
      .filterNil()
      .flatMapLatest { [weak self] enabled -> Observable<CLLocation> in
        guard let `self` = self, enabled else { return .empty() }
        return self.trackingService.track()
      }
      .map (Mutation.updateActivePosition)
  }
}
