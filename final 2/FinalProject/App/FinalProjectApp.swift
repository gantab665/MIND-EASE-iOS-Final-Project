//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//

import SwiftUI
import Firebase
import Stripe

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FinalProjectApp: App {
    init() {
        StripeAPI.defaultPublishableKey = "pk_test_51PADDCDGsMWdyJhClzcgtEzZaThNd3pGWfjpWEm55useKZKYaS6bEd41K5FgiL3Wpk0wwuUB0klSKI040xT0zZJF007rIW41im"
    }
   // @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
           HomeView()
            //    .environmentObject(locationViewModel)
                .environmentObject(authViewModel)
                .environmentObject(homeViewModel)
        }
        
    }
}
