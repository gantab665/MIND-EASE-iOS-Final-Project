//
//  PaymentConfig.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/27/24.
//

import Foundation

class PaymentConfig {
    
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfig = PaymentConfig()
    
    private init() { }
}
