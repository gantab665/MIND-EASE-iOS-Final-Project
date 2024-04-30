//
//  GeoPoint.swift
//  FinalProject
//
//  Created by Jerry Reddy on 22/04/24.
//

import Foundation
import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
