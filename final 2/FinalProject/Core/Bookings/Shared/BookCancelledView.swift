//
//  BookCancelledView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 23/04/24.
//

import SwiftUI

struct BookCancelledView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            
            Text(viewModel.bookCancelledMessage)
                .font(.headline)
                .padding(.vertical)
            
            Button {
                guard let user = viewModel.currentUser else { return }
                guard let book = viewModel.book else { return }
                
                if user.accountType == .patient {
                    if book.state == .doctorCancelled {
                        viewModel.deleteBook()
                    } else if book.state == .patientCancelled {
                        viewModel.book = nil
                    }
                } else {
                    if book.state == .patientCancelled {
                        viewModel.deleteBook()
                    } else if book.state == .doctorCancelled {
                        viewModel.book = nil
                    }
                }
                
            } label: {
                Text("OK")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32,height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct BookCancelledView_Previews: PreviewProvider {
    static var previews: some View{
        BookCancelledView()
    }
}
