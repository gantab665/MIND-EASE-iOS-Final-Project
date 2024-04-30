//
//  DeveloperPreview.swift
//  FinalProject
//
//  Created by Jerry Reddy on 19/04/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockBook = Book(
        patientUid: NSUUID().uuidString,
        doctorUid: NSUUID().uuidString,
        patientName: "Jerry Reddy",
        doctorName: "John Doe",
        patientLocation: .init(latitude: 37.123, longitude: -122.1),
        doctorLocation: .init(latitude: 37.123, longitude: -122.1),
        pickupLocationName: "Fenway Health",
        dropoffLocationName: "Starbucks",
        pickupLocationAddress: "123 Main St,Fenway St, MA",
        pickupLocation: .init(latitude: 37.456, longitude: -122.15),
        dropoffLocation: .init(latitude: 37.042, longitude: -122.2),
        bookCost: 47.0,
        distanceToPatient: 1000,
        travelTimeToPatient: 24,
        state: .rejected)
    
    let mockUser = User(
        fullname: "Bhavya Reddy",
        email: "test@gmail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude:42.3385, longitude: -71.0923),
        accountType: .patient,
        homeLocation: nil,
        workLocation: nil)
}
