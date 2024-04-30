//
//  User.swift
//  FinalProject
//
//  Created by Jerry Reddy on 18/04/24.
//

import Foundation
import Firebase

enum AccountType: Int, Codable {
    case patient
    case doctor
}

struct User: Codable{
    let fullname: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
