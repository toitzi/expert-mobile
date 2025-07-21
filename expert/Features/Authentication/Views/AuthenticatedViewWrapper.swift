//
//  AuthenticatedViewWrapper.swift
//  expert
//
//  Created by Tobias Oitzinger on 20.07.25.
//

import SwiftUI

struct AuthenticatedViewWrapper<Content: View>: View {
    @State private var isInlineTitle = false
    let content: () -> Content

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    scrollDetector()
                        .frame(height: 0)

                    content()
                }
                .padding(.horizontal)
            }
            .coordinateSpace(name: "scroll")
            .toolbar {
                ToolbarItem {
                    ProfileIconComponent()
                        .opacity(isInlineTitle ? 0 : 1)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .animation(.easeInOut(duration: 0.2), value: isInlineTitle)
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }

    @ViewBuilder
    private func scrollDetector() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            let isScrolled = minY < -5
            Color.clear
                .onAppear {
                    isInlineTitle = isScrolled
                }
                .onChange(of: isScrolled) { _, newVal in
                    isInlineTitle = newVal
                }
        }
    }
}
