//
//  SideMenuOptionViewModel.swift
//  FinalProject
//
//  Created by Jerry Reddy on 18/04/24.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case bookings
    case wallet
    case settings
    case messages
    case policy

    
    var title: String {
        switch self {
        case.bookings: return "Your Bookings"
        case.wallet: return "Wallet"
        case.settings: return "Settings"
        case.messages: return "Messages"
        case.policy: return "Privacy Policy"
        }
    }
    
    var imageName: String {
        switch self {
        case.bookings: return "list.bullet.rectangle"
        case.wallet: return "creditcard"
        case.settings: return "gear"
        case.messages: return "bubble.left"
        case .policy: return "doc.text"        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
