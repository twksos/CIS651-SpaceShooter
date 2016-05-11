//
//  Score.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/9/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import Foundation
import CoreLocation

class Location:NSObject, CLLocationManagerDelegate {
    static let instance = Location()
    
    let locationManager = CLLocationManager()
    var latitude:Double = 0
    var longtitude:Double = 0
    
    
    private override init() {
        super.init()
        // Ask for authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        print("inited")
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        // If location service enabled
        if CLLocationManager.locationServicesEnabled() {
            // Delegate location event to self
            locationManager.delegate = self
            // Set accuracy
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // Start update location
            locationManager.startUpdatingLocation()
        }
    }
    
    // Listen to location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
        latitude = currentLocation.latitude.datatypeValue
        longtitude = currentLocation.longitude.datatypeValue
    }
    
}