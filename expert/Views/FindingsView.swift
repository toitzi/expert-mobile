//
//  FindingsView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct FindingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Findings View")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("tab.findings".localized)
        }
    }
}

#Preview {
    FindingsView()
}