//
//  PatientArrivalView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 23/04/24.
//

import SwiftUI

struct PatientArrivalView: View {
    let book: Book
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            
            VStack {
                HStack {
                    Text("Your \(book.patientName) is arriving shortly at \(book.dropoffLocationName)")
                        .font(.headline)
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
            
            VStack {
                HStack {
                    Image("patient")
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
                        
                        Text ("\(book.bookCost.toCurrency())")
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                
                Divider()
            }
            .padding()
            
            Button {
                viewModel.cancelBookAsDoctor()
                
            } label: {
                Text("CANCEL BOOKING")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32,height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct PatientArrivalView_Previews: PreviewProvider {
    static var previews: some View{
        PatientArrivalView(book: dev.mockBook)
    }
}
