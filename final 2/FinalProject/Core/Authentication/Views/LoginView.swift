import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.yellow.opacity(0.7)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack {
                    Spacer()

                    VStack(spacing: 1) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 100)

                        Text("MindEase")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                    }
                    .padding()

                    Button {
                    } label: {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)

                    Spacer()

                    VStack {
                        HStack(spacing: 24) {
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Text("Sign in with Social")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }

                        HStack(spacing: 24) {
                            Button {
                                // Facebook Login Action
                            } label: {
                                Image("fb")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                            }

                            Button {
                                // Google Login Action
                            } label: {
                                Image("gg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                            }
                            
                            Button {
                                // Apple Login Action
                            } label: {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 36)
                                    .foregroundColor(.white) // Set color to black or appropriate color
                            }

                        }
                    }
                    .padding()

                    Button {
                        if validateFields() {
                            viewModel.signIn(withEmail: email, password: password)
                        } else {
                            showingAlert = true
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .foregroundColor(.black)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Login Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }

                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                            
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                }
                .padding(.bottom)  // Adds padding to the bottom to ensure content isn't too close to edges
            }
        }
    }

    func validateFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Both fields must be filled."
            return false
        } else if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        } else if password.count < 6 {
            errorMessage = "Password must be at least 8 characters."
            return false
        }
        return true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
