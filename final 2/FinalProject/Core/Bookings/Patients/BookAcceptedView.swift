//
//  BookAcceptedView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 23/04/24.
//

import SwiftUI

struct BookAcceptedView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            
            if let book = viewModel.book {
                
                VStack {
                    HStack{
                        Text("Meet you doctor at \(book.dropoffLocationName)")
                            .font(.body)
                            .frame(height: 44)
                            .lineLimit(2)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(book.travelTimeToPatient)")
                                .bold()
                            
                            Text("MIN")
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
                        Image("doc1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.doctorName)
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
                        
                      // doctor address info
                        
                        VStack(alignment: .center){
//                            Image("doc1")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 90, height: 70)
////
                            HStack {
                                Text("Fenway Health")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Boston")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(width: 160)
                            .padding(.bottom)
                            
                        }
                    }
                    
                    Divider()
                }
                .padding()
            }

            
            Button {
                viewModel.cancelBookAsPatient()
                
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


struct BookAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        BookAcceptedView().environmentObject(HomeViewModel())

    }
}
