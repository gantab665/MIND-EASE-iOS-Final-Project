import SwiftUI

struct WalletView: View {
    // Sample data for the wallet entries
    var transactions: [Transaction] = [
        Transaction(id: 1, date: "April 20, 2024", description: "Dr Liz Appointment", amount: "-$400.50"),
        Transaction(id: 2, date: "April 19, 2024", description: "Follow-up w/ Dr Liz", amount: "-$70.00"),
        Transaction(id: 3, date: "April 18, 2024", description: "Therapy Session", amount: "-$300.75"),
        Transaction(id: 4, date: "April 17, 2024", description: "Follow up - Therapy Session", amount: "-$70.00"),
        Transaction(id: 5, date: "April 17, 2024 - Refunded", description: "Follow up - Therapy Session", amount: "+$70.00"),
    ]

    // State to manage showing the add payment method screen
    @State private var showingAddPaymentMethod = false

    var body: some View {
        NavigationView {
            List {
                

                Section(header: Text("Transactions")) {
                    ForEach(transactions) { transaction in
                        TransactionCell(transaction: transaction)
                    }
                }
                
                Section(header: Text("Saved Cards")) {
                    CardDetailView(cardType: "Apple Pay", cardNumber: "•••• 1234")
                    CardDetailView(cardType: "American Express", cardNumber: "•••• 5678")
                }
                
                Section(header: Text("Payment Methods")) {
                    Button("Add/Edit Payment Methods") {
                        showingAddPaymentMethod = true
                    }
                }
            }
            .navigationTitle("Wallet")
            .sheet(isPresented: $showingAddPaymentMethod) {
                AddCardPaymentMethodView()
            }
        }
    }
}

// View for displaying a single transaction
struct TransactionCell: View {
    var transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                Text(transaction.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(transaction.amount)
                .foregroundColor(transaction.amount.contains("-") ? .red : .green)
        }
        .padding(.vertical, 8)
        .background(Color.theme.backgroundColor)

    }
}

// View for displaying saved card details
struct CardDetailView: View {
    var cardType: String
    var cardNumber: String

    var body: some View {
        HStack {
            Image(systemName: "creditcard")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(cardType)
                    .font(.headline)
                Text(cardNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.theme.backgroundColor)

    }
}

// Model for a transaction
struct Transaction: Identifiable {
    let id: Int
    let date: String
    let description: String
    let amount: String
}

// SwiftUI Preview provider
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
