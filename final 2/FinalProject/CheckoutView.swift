//
//  CheckoutView.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/27/24.
//

import SwiftUI

import Stripe

struct CheckoutView: View {
       @State private var message: String = ""
       @State private var isSuccess: Bool = false
       @State private var paymentMethodParams: STPPaymentMethodParams?
       let paymentGatewayController = PaymentGatewayController()
       
       private func pay() {
           guard let clientSecret = PaymentConfig.shared.paymentIntentClientSecret else {
               return
           }
           
           // Provide the amount directly, without depending on the cart
           let amount: Int = 1400 // Provide the amount in the smallest currency unit (e.g., cents)
           
           let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
           paymentIntentParams.paymentMethodParams = paymentMethodParams
           
           
           paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
               switch status {
                   case .failed:
                       message = "Failed"
                   case .canceled:
                       message = "Cancelled"
                   case .succeeded:
                       message = "Your payment has been successfully completed!"
               }
           }
       }
       
       var body: some View {
           VStack {
               List {
                   // Remove the section displaying cart items and total
                   Section {
                       // Stripe Credit Card TextField Here
                       STPPaymentCardTextField.Representable.init(paymentMethodParams: $paymentMethodParams)
                   } header: {
                       Text("Payment Information")
                   }
                   
                   HStack {
                       Spacer()
                       Button("Pay") {
                           pay()
                       }.buttonStyle(.plain)
                       Spacer()
                   }
                   
                   Text(message)
                       .font(.headline)
               }
               
               NavigationLink(isActive: $isSuccess, destination: {
                   Confirmation()
               }, label: {
                   EmptyView()
               })
               
               .navigationTitle("Checkout")
           }
       }
}

#Preview {
    CheckoutView()
}
