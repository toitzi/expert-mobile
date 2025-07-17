//
//  MainView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("tab.home".localized, systemImage: "house.fill")
                }
                .tag(0)
            
            FindingsView()
                .tabItem {
                    Label("tab.findings".localized, systemImage: "doc.text.magnifyingglass")
                }
                .tag(1)
            
            InvoicesView()
                .tabItem {
                    Label("tab.invoices".localized, systemImage: "doc.text.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("tab.settings".localized, systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .onAppear {
            // Force proper TabView appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainView()
}
