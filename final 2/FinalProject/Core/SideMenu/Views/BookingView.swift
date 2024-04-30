import SwiftUI

// Define the Booking model
struct Booking: Identifiable {
    let id: Int
    let title: String
    let dateTimeDescription: String
    let status: String
    var needsPayment: Bool
    
    var statusColor: Color {
        switch status {
        case "Confirmed": return .green
        case "Pending": return .orange
        case "Cancelled", "Completed": return .gray
        default: return .gray
        }
    }
}

struct BookingView: View {
    @State private var isActive: Bool = false

    var upcomingBookings: [Booking] = [
        Booking(id: 1, title: "Appointment w/ Dr Liz ", dateTimeDescription: "Tomorrow at 9 AM", status: "Confirmed", needsPayment: true),
        Booking(id: 2, title: "Post Therapy Checkup", dateTimeDescription: "Next Monday at 2 PM", status: "Pending", needsPayment: true)
    ]
    
    var previousBookings: [Booking] = [
           Booking(id: 3, title: "Dr Liz Appointment", dateTimeDescription: "Last Month", status: "Completed", needsPayment: false),
           Booking(id: 4, title: "Follow up Appointment", dateTimeDescription: "Two Months Ago", status: "Completed", needsPayment: false),
           Booking(id: 5, title: "Therapy Session", dateTimeDescription: "Two Months Ago", status: "Completed", needsPayment: false),
           Booking(id: 6, title: "Follow up - Therapy Session", dateTimeDescription: "Two Months Ago", status: "Cancelled", needsPayment: false)
       ]

    private func startCheckout(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://detailed-holy-fiber.glitch.me/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil)
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let clientSecret = json["clientSecret"] as? String {
                completion(clientSecret)
            } else {
                completion(nil)
            }
        }.resume()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Previous Appointments")) {
                        ForEach(previousBookings) { booking in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(booking.title).font(.headline)
                                    Text(booking.dateTimeDescription).font(.subheadline).foregroundColor(.gray)
                                }
                                Spacer()
                                Text(booking.status).foregroundColor(booking.statusColor)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Section(header: Text("Upcoming Appointments")) {
                        ForEach(upcomingBookings) { booking in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(booking.title).font(.headline)
                                    Text(booking.dateTimeDescription).font(.subheadline).foregroundColor(.gray)
                                }
                                Spacer()
                                if booking.needsPayment {
                                    Button("Pay Now") {
                                        startCheckout { clientSecret in
                                            if let clientSecret = clientSecret {
                                                PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                                                DispatchQueue.main.async {
                                                    isActive = true
                                                }
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                } else {
                                    Text(booking.status).foregroundColor(booking.statusColor)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                NavigationLink(destination: CheckoutView(), isActive: $isActive) { EmptyView() }
            }
            .navigationTitle("Bookings")
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}
