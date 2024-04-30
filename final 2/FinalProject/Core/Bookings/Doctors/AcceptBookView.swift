//
//  AcceptBookView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 21/04/24.
//

import SwiftUI
import MapKit

struct AcceptBookView: View {
    @State private var region: MKCoordinateRegion
    let book: Book
    let annotationItem: MindEaseLocation
    @EnvironmentObject var viewModel: HomeViewModel
    
    init(book: Book) {
        let center = CLLocationCoordinate2D(latitude: book.pickupLocation.latitude, longitude: book.pickupLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        self.region = MKCoordinateRegion(center: center, span: span)
        
        self.book = book
        self.annotationItem = MindEaseLocation(title: book.pickupLocationName, coordinate: book.pickupLocation.toCoordinate())
    }
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            // would you like to book view?
            VStack {
                HStack {
                    Text("Request for new appointment")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 42)
                    
                    Spacer()
                    
                    VStack {
                        Text("\(book.travelTimeToPatient)")
                            .bold()
                        
                        Text("min")
                            .bold()
                        
                    }
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                }
                
                .padding()
                
                Divider()
            }
            
            
            // user info view
            
            VStack {
                HStack {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.patientName)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(.systemYellow))
                                .imageScale(.small)
                            
                            Text("4.8")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("Your Earnings")
                        
                        Text (book.bookCost.toCurrency())
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                
                Divider()
            }
            .padding()
            
            // book location info view
            VStack {
                // book location info
                HStack {
                    // address info
                    VStack(alignment: .leading , spacing: 6) {
                        Text(book.pickupLocationName)
                            .font(.headline)
                        
                        Text(book.pickupLocationAddress)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                    
                    Spacer()
                    
                    // distance
                    VStack {
                        Text(book.distanceToPatient.distanceInMilesString())
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("mi")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        
                    }
                }
                .padding(.horizontal)
                
                // map
                Map(coordinateRegion: $region, annotationItems: [annotationItem]) { item in
                    MapMarker(coordinate: item.coordinate)
                }
                    .frame(height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.6), radius: 10)
                    .padding()
                
                // divider
                
                Divider()
            }
            
            // action buttons
            
            HStack {
                Button {
                    viewModel.rejectBook()
                    
                } label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemRed))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                }
                Spacer()
                
                Button {
                    viewModel.acceptBook()
                } label: {
                    Text("Accept")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}
    
    struct AcceptBookView_Previews: PreviewProvider {
        static var previews: some View{
            AcceptBookView(book: dev.mockBook)
        }
    }

