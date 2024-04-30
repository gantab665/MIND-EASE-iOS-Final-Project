//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Jerry Reddy on 19/04/24.
//
import Foundation

enum BookType: Int, CaseIterable, Identifiable {
    case psychiatrist
    case psychotherapist
    case psychologist
    case counselor
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .psychiatrist: return "Dr. Timothy"
        case .psychotherapist: return "Dr. Liza"
        case .psychologist: return "Dr. John"
        // Added description for the new case
        case .counselor: return "Dr. Emily"
        }
    }
    
    var imageName: String {
        switch self {
        case .psychiatrist: return "doc1"
        case .psychotherapist: return "doc2"
        case .psychologist: return "doc3"
        // Added imageName for the new case
        case .counselor: return "doc4"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .psychiatrist: return 5
        case .psychotherapist: return 20
        case .psychologist: return 10
        case .counselor: return 8
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1609.34 //  conversion for miles
        
        switch self {
        case .psychiatrist: return distanceInMiles * 15.5 + baseFare
        case .psychotherapist: return distanceInMiles * 17.0 + baseFare
        case .psychologist: return distanceInMiles * 20.75 + baseFare
        case .counselor: return distanceInMiles * 17.25 + baseFare
        }
    }
}
