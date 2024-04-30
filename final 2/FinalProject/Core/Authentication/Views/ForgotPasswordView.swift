import SwiftUI

struct ForgotPasswordView: View {
//    @State private var repassword = ""
    @State private var email = ""
//    @State private var newpassword = ""
    @State private var showAlert = false // State variable to control the alert

    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.yellow.opacity(0.7)]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                            .ignoresSafeArea()  // Ensure the gradient
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                Spacer()

                Text ("Reset Your Password")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                
                VStack {

                    VStack(spacing: 56) {
                      
                        
                        CustomInputField(text: $email,
                                         title: "Email Address",
                                         placeholder: "name@example.com")
                        
//                        CustomInputField(text: $newpassword,
//                                         title: "Create Password",
//                                         placeholder: "Enter Your Password")
//                        CustomInputField(text: $repassword,
//                                         title: "Full Name",
//                                         placeholder: "Enter Your Name")
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                                            showAlert.toggle() // Show the alert when the button is tapped
                                        }) {
                                            HStack {
                                                Text("Reset Password")
                                                    .foregroundColor(.black)
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.black)
                                            }
                                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                                        }
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding()
                                    }
                                }
                                .foregroundColor(.white)
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Check your e-mail"), message: Text("An e-mail has been sent to reset your password."), dismissButton: .default(Text("OK")))
                                }
                            }
        .navigationBarBackButtonHidden(true)
                            .background(Color.theme.backgroundColor)
                        }
                    }
        
        
        struct ForgotPasswordView_Previews: PreviewProvider {
            static var previews: some View{
                ForgotPasswordView()
            
        
            
        }
    }
