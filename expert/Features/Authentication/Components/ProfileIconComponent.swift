//
//  ProfileIconComponent.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ProfileIconComponent: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        if let userInfo = self.authManager.currentUser {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                
                Text(userInfo.initials)
                    .font(.system(size: 40 * 0.4, weight: .semibold))
                    .foregroundColor(Color(.label))
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    ProfileIconComponent()
}
