//
//  InvoicesView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct InvoicesView: View {
    
    @StateObject private var viewModel = InvoicesViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Invoices View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle("tab.invoices".localized)
        .refreshable {
            viewModel.refreshData()
        }
    }
}

#Preview {
    InvoicesView()
}
