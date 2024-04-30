import SwiftUI

struct RegistrationView: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingAlert = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.yellow.opacity(0.7)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("Create new Account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                
                VStack(spacing: 56) {
                    CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter Your Name")
                    CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                    CustomInputField(text: $password, title: "Create Password", placeholder: "Enter Your Password", isSecureField: true)
                }
                .padding(.leading)
                
                Spacer()
                
                Button {
                    if validateFields() {
                        viewModel.registerUser(withEmail: email, password: password, fullname: fullname)
                    } else {
                        showingAlert = true
                    }
                } label: {
                    HStack {
                        Spacer() // Use Spacer to push contents to center
                        Text("SIGN UP")
                            .foregroundColor(.black)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                        Spacer() // Use Spacer to ensure the content remains centered
                    }
                    .frame(maxWidth: .infinity, minHeight: 50) // Ensures the button stretches across the available width
                    .background(Color.white) // Sets the background color to white
                    .cornerRadius(10) // Applies rounded corners
                    .padding(.horizontal) // Applies horizontal padding
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Registration Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
                
            }
            .foregroundColor(.white)
        }
        .background(Color.theme.backgroundColor)
    }

    // Validation function
    func validateFields() -> Bool {
        if fullname.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "All fields are required."
            return false
        } else if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        } else if password.count < 8 {
            errorMessage = "Password must be at least 8 characters long."
            return false
        }
        return true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthViewModel())
    }
}
