//
//  BookLoadingView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 23/04/24.
//

import SwiftUI

struct BookLoadingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top,8)
            HStack {
                Text("Connectiong you to a doctor..")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Spinner(lineWidth: 6, height: 64, width: 64)
                    .padding()
            }
            .padding(.bottom, 24)
            
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct BookLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        BookLoadingView()
    }
}
