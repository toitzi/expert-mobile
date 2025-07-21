//
//  FindingsView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct FindingsView: View {
    
    @StateObject private var viewModel = FindingsViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Findings View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle("tab.home".localized)
        .refreshable {
            viewModel.refreshData()
        }
    }
}

#Preview {
    FindingsView()
}
