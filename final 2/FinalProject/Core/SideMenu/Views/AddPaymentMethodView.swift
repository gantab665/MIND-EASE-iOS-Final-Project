//
//  AddPaymentMethodView.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/23/24.
//

import SwiftUI

// View for adding or editing payment methods
struct AddCardPaymentMethodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    @State private var nameOnCard: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Card")) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Expiration Date (MM/YY)", text: $expirationDate)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                    TextField("Name on Card", text: $nameOnCard)
                }

                Section {
                    Button("Save Payment Method") {
                        // Handle the save action
                        print("Save Payment Method tapped")
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(cardNumber.isEmpty || expirationDate.isEmpty || cvv.isEmpty || nameOnCard.isEmpty)
                }
            }
            .navigationBarTitle("Add Payment Method", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .background(Color.theme.backgroundColor)

    }
}

