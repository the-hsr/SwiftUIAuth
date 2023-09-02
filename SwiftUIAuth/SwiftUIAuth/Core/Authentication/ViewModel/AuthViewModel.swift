//
//  AuthViewModel.swift
//  SwiftUIAuth
//
//  Created by Himanshu Singh on 02/09/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        print("Sign Up...")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("User: \(result)")
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            print("DB: \(user)")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signs out user on backend
            self.userSession = nil // wipes out user session and takes us to the login screen
            self.currentUser = nil // deattach from data model User
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        do {
            let user = Auth.auth().currentUser
            try user?.delete()
            self.userSession = nil // wipes out user session and takes us to the login screen
            self.currentUser = nil // deattach from data model User
        } catch {
            print("DEBUG: Failed to delete the user with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current User is: \(self.currentUser)")
    }
}
