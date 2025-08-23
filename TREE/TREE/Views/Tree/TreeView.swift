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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedType == .sublets ? "Sublets" : "Store")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .fontDesign(.rounded)
                        .foregroundStyle(Color("AccentColor").gradient)
                        .padding(.top)
                    
                    Text(selectedType == .sublets ? "Find your next home in \(profileViewModel.city)" : "Shop for great deals in \(profileViewModel.city)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray.gradient)
                    
                    
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 7)
                            .foregroundStyle(.red.gradient)
                        
                        Text("\(profileViewModel.city), \(profileViewModel.state)")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        DropDownMenuTreeView(selectedType: $selectedType)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .foregroundStyle(Color(.systemBackground).gradient)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Color").gradient)
                            .shadow(color: .primary.opacity(0.2), radius: 6, x: 0, y: 4)
                    }

                }
                .padding(.horizontal)
                
                if selectedType == .sublets {
                    SubletsContentView(viewModel: subletViewModel)
                        
                } else {
                    StoresContentView(viewModel: storeViewModel)
                }
            }
            .navigationDestination(for: Sublets.self) { sublet in
                SubletListingDetailView(sublet: sublet)
                    .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(for: Stores.self) { store in
                StoreListingDetailView(store: store)
                    .toolbar(.hidden, for: .tabBar)
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
                        
                    
                }
            }
        }
        .padding(.horizontal)
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
                        
                    
                }
            }
        }
        .padding()
    }
}


#Preview {
    TreeView()
}
