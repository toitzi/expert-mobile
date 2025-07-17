//
//  ContentView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        if authManager.isAuthenticated {
            MainView()
        } else {
            SplashView()
        }
    }
}

#Preview {
    ContentView()
}
