//
//  FindingsView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct FindingsView: View {
    
    @ObservedObject var viewModel: FindingsViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            // Show skeleton loaders on initial load
            if viewModel.isLoadingFindings && viewModel.findings.isEmpty {
                ForEach(0..<5, id: \.self) { _ in
                    FindingSkeletonRow()
                }
            } else {
                ForEach(viewModel.findings) { finding in
                        FindingRowView(finding: finding)
                            .onAppear {
                                // Check if this is one of the last 3 items
                                if let index = viewModel.findings.firstIndex(where: { $0.id == finding.id }),
                                   index >= viewModel.findings.count - 3 {
                                    viewModel.loadMore()
                                }
                            }
                }
            }
                    
            // Loading indicator for pagination
                    if viewModel.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                            Spacer()
                        }
                    }
                    
                    // End of list indicator
                    if !viewModel.hasMorePages && !viewModel.findings.isEmpty {
                        Text("No more findings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
        }
        .padding(.horizontal)
        .overlay {
            if !viewModel.isLoadingFindings && viewModel.findings.isEmpty {
                ContentUnavailableView(
                    "No Findings",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("You don't have any findings yet.")
                )
            }
        }
        .navigationTitle("tab.findings".localized)
        .onAppear {
            // Load data if not already loaded
            if viewModel.findings.isEmpty && !viewModel.isLoadingFindings && !viewModel.isLoadingMore {
                viewModel.loadFindingsData()
            }
        }
    }
}

// Finding Row View Component
struct FindingRowView: View {
    let finding: Finding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(finding.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(finding.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
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
    FindingsView(viewModel: FindingsViewModel())
}
