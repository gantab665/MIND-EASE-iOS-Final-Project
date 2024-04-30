//
//  LocationSearchActivationView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            Text("Search nearby hospitals")
                .foregroundColor(Color(.darkGray))
                .padding(.leading, 16)  // Adding padding to the left side of the text
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black, radius: 6)
        )
    }
}


struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}

    


