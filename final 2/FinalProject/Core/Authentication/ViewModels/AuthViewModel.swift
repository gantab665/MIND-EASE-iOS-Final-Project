//
//  AuthViewModel.swift
//  FinalProject
//
//  Created by Meghana Pathapati on 4/17/24.
//


import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    private let service = UserService.shared

    init() {
        self.userSession = FirebaseAuth.Auth.auth().currentUser
        if userSession != nil {
            fetchUser()
        }
    }

    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
            self.fetchUser()
        }
    }

    func registerUser(withEmail email: String, password: String, fullname: String) {
        guard let location = LocationManager.shared.userLocation else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }

            guard let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser

            let user = User(fullname: fullname,
                            email: email,
                            uid: firebaseUser.uid,
                            coordinates: GeoPoint(latitude:location.latitude, longitude: location.longitude),
                            accountType: .doctor)
            self.currentUser = user
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }

            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser) { error in
                if let error = error {
                    print("DEBUG: Error setting user data in Firestore: \(error.localizedDescription)")
                    return
                }
                
            }
        }
    }

    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }

    func fetchUser() {
        service.$user
            .sink { user in
                
                self.currentUser = user
                
            }
            .store(in: &cancellables)
            
        }
            
        
    }


