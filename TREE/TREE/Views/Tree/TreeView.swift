//
//  TreeView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct TreeView: View {
    @State private var selectedType: DropDownMenuTreeView.TreeType = .sublets
    @EnvironmentObject var storeViewModel: StoresViewModel
    @EnvironmentObject var subletViewModel: SubletsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(selectedType == .sublets ? "Sublets" : "Store")
                            .resizable()
                            .frame(width: selectedType == .sublets ? 120 : 100, height: 24)
                        
                        Spacer()
                        
                        DropDownMenuTreeView(selectedType: $selectedType)
                    }
                    .padding(.bottom)
                    SearchAndFilterBar()
                }
                
                .padding()
                
                if selectedType == .sublets {
                    SubletsContentView(viewModel: subletViewModel)
                } else {
                    StoresContentView(viewModel: storeViewModel)
                }
            }
            .navigationDestination(for: Sublets.self) { sublet in
                SubletListingDetailView(sublet: sublet)
            }
            .navigationDestination(for: Stores.self) { store in
                StoreListingDetailView(store: store)
            }
        }
        .foregroundStyle(.primary)
        // instead of fetching all the data, fetch data that we only need
    }
}

// MARK: - Sublets Content View
struct SubletsContentView: View {
    @ObservedObject var viewModel: SubletsViewModel
    var body: some View {
        LazyVStack(spacing: 16) {
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
}

// MARK: - Stores Content View
struct StoresContentView: View {
    @ObservedObject var viewModel: StoresViewModel
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(viewModel.stores) { store in
                NavigationLink(value: store) {
                    StoreListingView(store: store)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }
        }
        .padding()
    }
}


#Preview {
    TreeView()
}
