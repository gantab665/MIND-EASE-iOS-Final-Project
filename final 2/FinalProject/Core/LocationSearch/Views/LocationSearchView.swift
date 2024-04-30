//
//  LocationSearchView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            // HEADER VIEW
            HStack {
                Spacer()

                VStack {
                    
                    Circle()
                        .fill(Color(.blue))
                        .frame(width: 6, height: 24)
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("Current Location", text: $startLocationText)
                        .frame(height: 32)
                        .backgroundStyle(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Search nearby hospitals", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .backgroundStyle(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 80)
            
            Divider()
                .padding(.vertical)
            
            // List View
            LocationSearchResultsView(viewModel: viewModel, config: .book)
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
             // Ensure ViewModel is provided
    }
}

