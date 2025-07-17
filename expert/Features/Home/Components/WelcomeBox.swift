//
//  WelcomeBox.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct WelcomeBox: View {
    let user: UserInfo?
    
    private var firstName: String {
        user?.name.split(separator: " ").first.map(String.init) ?? "User"
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "home.good_morning".localized
        case 12..<17:
            return "home.good_afternoon".localized
        default:
            return "home.good_evening".localized
        }
    }
    
    private var randomEmoji: String {
        ["👋", "😊", "🎉", "✨", "🌟", "💫", "🎊", "🌈"].randomElement() ?? "👋"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\("home.hello".localized), \(firstName) \(randomEmoji)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            ProfileIconView(userInfo: user, size: 50)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}