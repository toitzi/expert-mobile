//
//  expertApp.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

@main
struct expertApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        // App became active - refresh user info if authenticated
                        if authManager.isAuthenticated {
                            Task {
                                await authManager.fetchUserInfo()
                            }
                        }
                    case .inactive:
                        break
                    case .background:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}
