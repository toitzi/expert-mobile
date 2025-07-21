//
//  CounterWidget.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct CounterWidget: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            HStack {
                Text("\(count)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                    .animation(.easeInOut(duration: 0.3), value: count)
                
                Spacer()
            }
            
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}
