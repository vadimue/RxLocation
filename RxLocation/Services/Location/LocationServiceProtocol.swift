import Foundation
import CoreLocation
import RxSwift

protocol LocationServiceProtocol {
  typealias LocationManagerConfigurator = (CLLocationManager) -> Void
  
  func location(_ managerFactory: LocationManagerConfigurator?) -> Observable<CLLocation>
  
  func singleLocation(_ managerFactory: LocationManagerConfigurator?) -> Observable<CLLocation>
  
  func permissionRequest(targetLevel: LocationAuthorizationLevel,
                         _ managerFactory: LocationManagerConfigurator?)
    -> Observable<LocationAuthorizationLevel>
}

extension LocationServiceProtocol {
  
  public func location(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    return location(managerFactory)
  }
  
  public func singleLocation(_ managerFactory: LocationManagerConfigurator? = nil) -> Observable<CLLocation> {
    return singleLocation(managerFactory)
  }
  
  public func permissionRequest(targetLevel: LocationAuthorizationLevel,
                                _ managerFactory: LocationManagerConfigurator? = nil)
    -> Observable<LocationAuthorizationLevel> {
      return permissionRequest(targetLevel: targetLevel, managerFactory)
  }
}
