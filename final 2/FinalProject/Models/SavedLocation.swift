//
//  SavedLocation.swift
//  FinalProject
//
//  Created by Jerry Reddy on 19/04/24.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
    
}
