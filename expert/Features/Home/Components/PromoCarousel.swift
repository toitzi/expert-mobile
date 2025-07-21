//
//  PromoCarousel.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct PromoCarousel: View {
    @Binding var currentIndex: Int
    
    // TODO: Replace with data from backend
    let promos = [
        PromoItem(
            title: "home.promo1_title".localized,
            subtitle: "home.promo1_subtitle".localized,
            icon: "doc.text.magnifyingglass",
            gradientColors: [Color.purple, Color.pink]
        ),
        PromoItem(
            title: "home.promo2_title".localized,
            subtitle: "home.promo2_subtitle".localized,
            icon: "chart.line.uptrend.xyaxis",
            gradientColors: [Color.blue, Color.cyan]
        ),
        PromoItem(
            title: "home.promo3_title".localized,
            subtitle: "home.promo3_subtitle".localized,
            icon: "bell.badge",
            gradientColors: [Color.orange, Color.red]
        )
    ]
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<promos.count, id: \.self) { index in
                PromoSlide(item: promos[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct PromoItem {
    let title: String
    let subtitle: String
    let icon: String
    let gradientColors: [Color]
}

struct PromoSlide: View {
    let item: PromoItem
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: item.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                    
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color(.label).opacity(0.9))
                        .lineLimit(2)
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(systemName: item.icon)
                    .font(.system(size: 60))
                    .foregroundColor(Color(.label).opacity(0.3))
            }
            .padding()
        }
        .cornerRadius(20)
        .padding(.horizontal, 4)
    }
}
