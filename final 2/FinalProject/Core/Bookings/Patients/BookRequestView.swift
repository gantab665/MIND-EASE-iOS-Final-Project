//
//  BookRequestView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import SwiftUI

struct BookRequestView: View {
    @State private var selectedBookType: BookType = .psychiatrist
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var navigateToWalletView = false
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            
            // trip info view
            HStack {
                // indicator view
                VStack {
                    Circle()
                        .fill(Color(.systemGray))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                }
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Your Location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(homeViewModel.pickupTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if let location = homeViewModel.selectedMindEaseLocation{
                            Text(location.title)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        
                        Spacer()
                        
                        Text(homeViewModel.dropOffTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            // ride type selection view
            
            Text("DOCTORS IN YOUR VICINITY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(BookType.allCases, id: \.self) { type in
                        VStack(alignment: .leading) {
                            Image(type.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.description)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text(homeViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                            .padding(8)
                            
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(type == selectedBookType ? .white : Color.theme.primaryTextColor)
                        .background(type == selectedBookType ? .blue : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedBookType ? 1.01 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedBookType = type
                            }
                        }
                        
                    }
                }
            }
            
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            // payment option view
            
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("*** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
                
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                navigateToWalletView = true
            }
            // request ride button
            
            Button {
                homeViewModel.requestBook()
                
            } label: {
                Text("CONFIRM BOOKING")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32,height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(12)
        .navigationDestination(isPresented: $navigateToWalletView) {
            WalletView()
        }
    }
    
    struct BookRequestView_Previews: PreviewProvider {
        static var previews: some View {
            BookRequestView().environmentObject(HomeViewModel())
        }
    }
}
