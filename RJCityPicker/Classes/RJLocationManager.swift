//
//  RJLocationManager.swift
//  citypick
//
//  Created by RJ on 2018/11/16.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
import CoreLocation
public typealias RJLocationHandler = (_ city:String?,_ error:Error?) -> Void
public class RJLocationManager: NSObject {
   public static let manager = RJLocationManager()
    //MARK: - 属性
    private var locationManager = CLLocationManager()
    private var locationHanler : RJLocationHandler?

    //MARK: - 公有方法
    /// 定位
    public func location(_ handler:RJLocationHandler?) -> Void {
        
        locationHanler  = handler
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter  = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter  = 100
        requireAuthorized()
    }
    private func requireAuthorized() -> Void {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            startLocation()
        }
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
            print("定位权限被拒绝")
        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            startLocation()
        }
    }
    private func startLocation() -> Void {
        locationManager.startUpdatingLocation()
    }
}
extension RJLocationManager:CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationHanler = locationHanler else { return  }
        guard let location = locations.last else { return  }
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks:[CLPlacemark]?,error: Error?) in
            guard let placemark = placemarks?.last else {return}
            guard let addressInfo = placemark.addressDictionary else {return}
            guard let city = addressInfo["City"] as? String else {return}
            locationHanler(city,nil)
        }
        locationManager.stopUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let locationHanler = locationHanler else { return  }
        locationHanler(nil,error)
        locationManager.stopUpdatingLocation()
    }
}
