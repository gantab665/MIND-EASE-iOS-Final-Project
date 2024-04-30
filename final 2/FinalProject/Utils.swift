//
//  Utils.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/27/24.
//

import Foundation


func formatPrice(_ price: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: price))
}
