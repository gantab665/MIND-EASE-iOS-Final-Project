//
//  DoctorAnnotation.swift
//  FinalProject
//
//  Created by Jerry Reddy on 19/04/24.
//

import MapKit
import Firebase

class DoctorAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(doctor: User) {
        self.uid = doctor.uid
        self.coordinate = CLLocationCoordinate2D(latitude: doctor.coordinates.latitude,
                                                 longitude: doctor.coordinates.longitude)
    }
}
