//
//  MessagesView.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/23/24.
//

import SwiftUI

struct MessagesView: View {
    @State private var showingReport = false
    @State private var sharingReport = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Direct Communications")) {
                    NavigationLink("Chat with Your Therapist", destination: Text("Chat Interface Goes Here"))
                    NavigationLink("Peer Support Groups", destination: Text("Group Chat Interface"))
                }

                Section(header: Text("Therapy Sessions")) {
                    Button("Review Therapy Reports") {
                        self.showingReport = true
                    }
                    .sheet(isPresented: $showingReport) {
                        Text("Therapy Report Details") // Placeholder for therapy report view
                    }

                    Button("Share Therapy Reports") {
                        self.sharingReport = true
                    }
                    .sheet(isPresented: $sharingReport) {
                        Text("Share Interface Here") // Placeholder for share functionality
                    }
                }

                Section(header: Text("Educational Resources")) {
                    NavigationLink("Articles and Videos", destination: Text("Resource List"))
                    NavigationLink("Activity Suggestions", destination: Text("Activities List"))
                }
            }
            .navigationTitle("Messages")
            .background(Color.theme.backgroundColor)

        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
