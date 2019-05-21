//
//  LocationService.swift
//  Agnihotra Buddy
//
//  Created by VISHAL SETH on 20/05/19.
//  Copyright © 2019 Infoicon Technologies. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService : NSObject, CLLocationManagerDelegate {
    
    static let locMngr = LocationService()
    
    var locationManager : CLLocationManager = CLLocationManager()

    override init() {
        super.init()
        
        let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        print("init LocationData")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Found location")
        if ((locations.last?.horizontalAccuracy != 0)) {
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    
}
