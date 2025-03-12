//
//  SwiftUIAuthApp.swift
//  SwiftUIAuth
//
//  Created by Himanshu Singh on 02/09/23.
//

import SwiftUI
import Firebase

@main
struct SwiftUIAuthApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
        }
    }
} 
