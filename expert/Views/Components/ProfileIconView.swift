//
//  ProfileIconView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ProfileIconView: View {
    let userInfo: UserInfo?
    let size: CGFloat
    
    init(userInfo: UserInfo?, size: CGFloat = 60) {
        self.userInfo = userInfo
        self.size = size
    }
    
    var body: some View {
        if let userInfo = userInfo {
            // Hydrated state - show initials
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: size, height: size)
                
                Text(userInfo.initials)
                    .font(.system(size: size * 0.4, weight: .semibold))
                    .foregroundColor(.white)
            }
        } else {
            // Skeleton loading state
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.gray.opacity(0.3),
                                    Color.gray.opacity(0.5),
                                    Color.gray.opacity(0.3)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: size, height: size)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.clear,
                                            Color.white,
                                            Color.clear
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .rotationEffect(.degrees(25))
                                .offset(x: -size)
                                .animation(
                                    Animation.linear(duration: 1.5)
                                        .repeatForever(autoreverses: false),
                                    value: UUID()
                                )
                        )
                )
        }
    }
}