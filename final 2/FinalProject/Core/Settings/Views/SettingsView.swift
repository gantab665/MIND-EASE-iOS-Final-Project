//
//  SettingsView.swift
//  FinalProject
//
//  Created by Jerry Reddy on 18/04/24.
//

import SwiftUI

import SwiftUI




struct GradientToggleStyle: ToggleStyle {
    let onGradient: LinearGradient
    let offColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    configuration.isOn ? onGradient : LinearGradient(colors: [offColor, offColor], startPoint: .leading, endPoint: .trailing)
                )
                .frame(width: 51, height: 31)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 27, height: 27)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isOn)
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

struct SettingsView: View {
    private let user: User
    @State private var notificationsEnabled = false  // Default to false or true based on your app's needs

    @EnvironmentObject var viewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    var body: some View {
        VStack {
            List {
                Section {
                    // user info header
                    HStack {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullname)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                            
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                }
                
                
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(config: viewModel)
                        } label: {
                            SavedLocationRowView(viewModel: viewModel, user: user)
                        }
                        
                    }
                    
                }
                
                Section("Settings") {
                    HStack {
                        SettingsRowView(imageName: "bell.circle.fill", title: "Notifications", tintColor: Color(.systemPurple))
                        
                        Spacer(minLength: 20) // Adjusts the minimum length of the spacer to increase space
                        
                        Toggle("", isOn: $notificationsEnabled)
                            .toggleStyle(GradientToggleStyle(
                                onGradient: LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.yellow.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                offColor: Color.gray.opacity(0.2)
                            ))
                            .frame(width: 51, height: 31)
                    }

                    
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "Payment Methods", tintColor: Color(.systemBlue))
                }

                
                Section("Account") {
                                    NavigationLink(destination: RegistrationView()
                                                    .environmentObject(viewModel)
                                                    .navigationBarBackButtonHidden(true)) { // Hiding the back button on RegistrationView
                                        SettingsRowView(imageName: "dollarsign.circle.fill", title: "Make Money", tintColor: .green)
                                    }


                    
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.systemRed))
                    
                        .onTapGesture {
                            viewModel.signout()
                            
                        }
                    
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.theme.backgroundColor)

    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: dev.mockUser)
        }
    }
}
