//
//  MapViewState.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case bookRequested
    case bookRejected
    case bookAccepted
    case bookCancelledByPatient
    case bookCancelledByDoctor
}
