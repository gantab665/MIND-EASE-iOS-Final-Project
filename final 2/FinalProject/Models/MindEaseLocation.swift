//
//  MindEaseLocation.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import CoreLocation

struct MindEaseLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
