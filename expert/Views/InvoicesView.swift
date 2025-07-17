//
//  InvoicesView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct InvoicesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Invoices View")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("tab.invoices".localized)
        }
    }
}

#Preview {
    InvoicesView()
}