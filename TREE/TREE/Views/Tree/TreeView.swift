//
//  TreeView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct TreeView: View {
    @StateObject var viewModel = SubletsViewModel(service: SubletsService())
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Image("Sublets")
                        .resizable()
                        .frame(width: 120, height: 24)
                        .padding(.bottom)
                    SearchAndFilterBar()
                }
                .padding()
                
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.sublets) { sublet in
                        NavigationLink(value: sublet) {
                            SubletListingView(sublet: sublet)
                                .frame(height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Sublets.self) { sublet in
                SubletListingDetailView(sublet: sublet)
            }
        }
    }
}

#Preview {
    TreeView()
}
