//
//  SkeletonView.swift
//  expert
//
//  Created by Tobias Oitzinger on 23.07.25.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(height: CGFloat = 20, cornerRadius: CGFloat = 4) {
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor.systemGray5),
                Color(UIColor.systemGray4),
                Color(UIColor.systemGray5)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: height)
        .cornerRadius(cornerRadius)
        .opacity(isAnimating ? 0.6 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct FindingSkeletonRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Title skeleton
                    SkeletonView(height: 20, cornerRadius: 4)
                        .frame(width: 200)
                    
                    // Date skeleton
                    SkeletonView(height: 14, cornerRadius: 4)
                        .frame(width: 100)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    VStack(spacing: 12) {
        FindingSkeletonRow()
        FindingSkeletonRow()
        FindingSkeletonRow()
    }
    .padding()
}