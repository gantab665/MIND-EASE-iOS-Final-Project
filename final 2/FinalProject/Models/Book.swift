//
//  Book.swift
//  FinalProject
//
//  Created by Jerry Reddy on 21/04/24.
//

import FirebaseFirestoreSwift
import Firebase

enum BookState: Int, Codable {
    case requested
    case rejected
    case accepted
    case patientCancelled
    case doctorCancelled
}

struct Book: Identifiable, Codable {
    @DocumentID var bookId: String?
    let patientUid: String
    let doctorUid: String
    let patientName: String
    let doctorName: String
    let patientLocation: GeoPoint
    let doctorLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let bookCost: Double
    var distanceToPatient: Double
    var travelTimeToPatient: Int
    var state: BookState
    
    var id: String {
        return bookId ?? ""
    }
}
