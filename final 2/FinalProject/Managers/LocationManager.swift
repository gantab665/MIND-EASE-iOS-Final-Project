//
//  LocationManager.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Use guard to make sure locations array is not empty and extract the last location
        guard let location = locations.last else { return }
        self.userLocation = location.coordinate
        locationManager.stopUpdatingLocation()  // Optionally, you might want to stop updating the location depending on your app's need
    }
}
