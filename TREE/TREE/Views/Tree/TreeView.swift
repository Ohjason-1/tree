//
//  TreeView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct TreeView: View {
    @State private var selectedType: DropDownMenu.TreeType = .sublets
    @StateObject var viewModel = TreeViewModel(service: TreeService())
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(selectedType == .sublets ? "Sublets" : "Store")
                            .resizable()
                            .frame(width: selectedType == .sublets ? 120 : 100, height: 24)
                        
                        Spacer()
                        
                        DropDownMenu(selectedType: $selectedType)
                    }
                    .padding(.bottom)
                    SearchAndFilterBar()
                }
                
                .padding()
                
                if selectedType == .sublets {
                    SubletsContentView(viewModel: viewModel)
                        .task { await viewModel.fetchData() }
                } else {
                    StoresContentView(viewModel: viewModel)
                        .task { await viewModel.fetchData() }
                }
            }
            .navigationDestination(for: Sublets.self) { sublet in
                SubletListingDetailView(sublet: sublet)
            }
            .navigationDestination(for: Stores.self) { store in
                //StoreListingDetailView(store: store)
            }
        }
        // instead of fetching all the data, fetch data that we only need
        .onChange(of: selectedType) { oldType, newType in
            switch newType {
            case .sublets:
                viewModel.selectedType = .sublets
            case .stores:
                viewModel.selectedType = .stores
            }
        }
    }
}

// MARK: - Sublets Content View
struct SubletsContentView: View {
    @ObservedObject var viewModel: TreeViewModel
    var body: some View {
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
}

// MARK: - Stores Content View
struct StoresContentView: View {
    @ObservedObject var viewModel: TreeViewModel
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

// MARK: - Dropdown Menu
struct DropDownMenu: View {
    enum TreeType: String, CaseIterable {
        case sublets = "house.circle"
        case stores = "storefront.circle"
        var displayName: String {
            switch self {
            case .sublets: return "Sublets"
            case .stores: return "Store"
            }
        }
    }
    
    @Binding var selectedType: TreeType
    
    var body: some View {
        VStack {
            Menu {
                ForEach(TreeType.allCases, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        HStack {
                            Image(systemName: type.rawValue)
                            Text(type.displayName)
                            Spacer()
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: selectedType.rawValue)
                        .font(.title3)
                    
                    Image(systemName: "chevron.up.chevron.down")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 65, height: 35)
        .background(Color(.systemGray2).gradient)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TreeView()
}
