import Foundation
import CoreLocation
import RxSwift

// MARK: Errors
enum LocationError: Error {
  case locationError(CLError.Code)
  case undefined
}

enum LocationAuthorizationError: Error {
  case noAccess
  case disabled
}

// MARK: Location authorization lever
public enum LocationAuthorizationLevel {
  case whenInUse
  case always
}

public func < (lhs: LocationAuthorizationLevel, rhs: LocationAuthorizationLevel) -> Bool {
  return lhs == .whenInUse && rhs == .always
}
extension LocationAuthorizationLevel: Comparable { }

public extension LocationAuthorizationLevel {
  public init?(status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways: self = .always
    case .authorizedWhenInUse: self = .whenInUse
    default: return nil
    }
  }
}

// MARK: Location service implementation

final class LocationService: NSObject, LocationServiceProtocol {
  typealias LocationManagerBuilder = () -> CLLocationManager
  
  private let locationManagerBuilder: LocationManagerBuilder
  
  required init(_ builder: @escaping LocationManagerBuilder) {
    self.locationManagerBuilder = builder
  }
  
  public func location(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    let manager = locationManagerBuilder()
    managerFactory?(manager)
    
    return manager.rx.locationSignal
      .do(onSubscribe: {
        manager.startUpdatingLocation()
      }, onDispose: {
        manager.stopUpdatingLocation()
      })
  }
  
  public func singleLocation(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    let manager = locationManagerBuilder()
    managerFactory?(manager)
    
    return Observable.merge([manager.rx.errorSignal, manager.rx.locationSignal])
      .take(1)
      .do(onSubscribe: {
        manager.startUpdatingLocation()
      }, onDispose: {
        manager.stopUpdatingLocation()
      })
  }
  
  public func permissionRequest(targetLevel: LocationAuthorizationLevel,
                                _ managerFactory: LocationManagerConfigurator? = nil)
    -> Observable<LocationAuthorizationLevel> {
      let manager = locationManagerBuilder()
      guard type(of: manager).locationServicesEnabled() else {
        return Observable.error(LocationAuthorizationError.disabled)
      }
      
      let translateStatus: (CLAuthorizationStatus) -> Observable<LocationAuthorizationLevel> = { status in
        if let level = LocationAuthorizationLevel(status: status), level >= targetLevel {
          return Observable.just(level)
        } else {
          switch status {
          case .denied:
            return Observable.error(LocationAuthorizationError.noAccess)
          case .restricted:
            return Observable.error(LocationAuthorizationError.noAccess)
          default:
            assertionFailure("CLAuthorizationStatus should not be .NotDetermined by now")
            return Observable.error(LocationAuthorizationError.noAccess)
          }
        }
      }
      
      return Observable<CLAuthorizationStatus>.just(type(of: manager).authorizationStatus())
        .flatMapLatest({ status -> Observable<LocationAuthorizationLevel> in
          if case .notDetermined = status {
            return manager.rx.didChangeAuthorizationStatus
              .do(onSubscribe: {
                switch targetLevel {
                case .always: manager.requestAlwaysAuthorization()
                case .whenInUse: manager.requestWhenInUseAuthorization()
                }
              })
              .filter { $0 != .notDetermined }
              .take(1)
              .flatMapLatest(translateStatus)
          } else {
            return translateStatus(status)
          }
        })
  }
}

// MARK: CLLocationManager extensions

extension Reactive where Base: CLLocationManager {
  public var errorSignal: Observable<CLLocation> {
    return self.didFailWithError
      .flatMapLatest { error in
        return Observable<CLLocation>.error(error)
    }
  }
  
  public var locationSignal: Observable<CLLocation> {
    return self.didUpdateLocations
      .filter { !$0.isEmpty }
      .map { locations in
        let sortedLocations = locations.sorted(by: { $0.timestamp < $1.timestamp })
        let lastIndex = sortedLocations.count - 1
        return sortedLocations[lastIndex]
    }
  }
}
