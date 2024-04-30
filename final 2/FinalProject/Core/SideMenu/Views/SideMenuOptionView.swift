//
//  SideMenuOptionView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 18/04/24.
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.title2)
                .imageScale(.medium)
            
            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
            
        }
        .foregroundColor(Color.theme.primaryTextColor)
        
    }
}

struct SideMenuOptionView_Preview: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(viewModel: .bookings)
    }
}
