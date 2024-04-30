import SwiftUI

struct SideMenuView: View {
    
    private let user: User
    
    // Initialize with a user object
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
//        Spacer()
        
        VStack(alignment: .leading, spacing: 30) {
            // User info header
            VStack(alignment: .leading, spacing: 32) {
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
                            .opacity(0.77)
                    }
                }
            }
            
            // Section: Do more with your account
            VStack(alignment: .leading, spacing: 16) {
                Text("Do more with your account")
                    .font(.system(size: 16, weight: .semibold))
                
                Button(action: {
                    // Action for the button
                }) {
                    HStack {
                        Image(systemName: "dollarsign.square")
                            .font(.title2)
                            .imageScale(.medium)
                        
                        Text("Start Earning Today")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 6)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .fixedSize()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.yellow.opacity(0.7)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(10)
                }
                Rectangle()
                    .frame(width: 296, height: 0.75)
                    .opacity(0.7)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 6)
//                    .padding(.bottom, 20) // Added padding to create space after the divider
            }
            
//            Spacer()
            
            // Option list
            VStack {
                ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                    NavigationLink(value: viewModel) {
                        SideMenuOptionView(viewModel: viewModel)
                            .padding()
                    }
                }
            }
            .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                switch viewModel {
                case .bookings:
                    BookingView()
                case .wallet:
                    WalletView()
                case .settings:
                    SettingsView(user: user)
                case .messages:
                    MessagesView()
                case .policy:
                    PrivacyPolicyView()
                }
            }
            Spacer()
            
            // Copyright footer
            Text("© 2024 MindEase")
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: -35)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 70)
        .background(Color.theme.backgroundColor)

        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    struct SideMenuView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                SideMenuView(user: dev.mockUser)
            }
        }
    }
}
