//
//  MainView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("tab.home".localized, systemImage: "house.fill")
                }
            
            FindingsView()
                .tabItem {
                    Label("tab.findings".localized, systemImage: "doc.text.magnifyingglass")
                }
            
            InvoicesView()
                .tabItem {
                    Label("tab.invoices".localized, systemImage: "doc.text.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("tab.settings".localized, systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
