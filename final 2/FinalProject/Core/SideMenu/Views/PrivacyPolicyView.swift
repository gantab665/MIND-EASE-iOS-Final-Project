//
//  PrivacyPolicyView.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/25/24.
//

import SwiftUI


struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                Text("""
                    **Introduction**
                    Welcome to the MindEase Privacy Policy. Your privacy is of paramount importance to us. This Privacy Policy provides information about how we collect, use, and disclose your information when you use our services.

                    **HIPAA Compliance**
                    As a provider of mental health services, we adhere strictly to the Health Insurance Portability and Accountability Act (HIPAA), which protects the privacy and security of certain health information. We implement robust safeguards to ensure the confidentiality, integrity, and availability of protected health information (PHI).

                    **Data Collection**
                    We collect various types of information, including information that may identify you as an individual ("Personal Information"). This includes but is not limited to your name, email address, contact details, and any other information we might need to provide our services effectively.

                    **Use of Data**
                    We use the information we collect for various purposes:
                    - To provide and maintain our Service
                    - To notify you about changes to our Service
                    - To allow you to participate in interactive features of our Service when you choose to do so
                    - To provide customer care and support

                    **Security**
                    The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.

                    **Changes to This Privacy Policy**
                    We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

                    **Contact Us**
                    If you have any questions about this Privacy Policy, please contact us at MindEase@gmail.com.
                    """)
                .padding()

                Spacer()
            }
            .padding()
            .background(Color.theme.backgroundColor)

        }
//        .navigationBarTitle("Privacy Policy", displayMode: .inline)
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PrivacyPolicyView()
        }
    }
}

