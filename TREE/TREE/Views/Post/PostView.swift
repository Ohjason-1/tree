//
//  PostView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/30/25.
//

import SwiftUI

struct PostView: View {
    @State private var selectedType: PostDropDownMenuView.TreeType = .sublets
    @StateObject var storeViewModel = StoresViewModel()
    @StateObject var subletViewModel = SubletsViewModel()
    @Binding var tabIndex: Int
    var body: some View {
        NavigationStack {
            if selectedType == .sublets {
                SubletPostView(viewModel: subletViewModel, tabIndex: $tabIndex, selectedType: $selectedType)
            } else {
                StorePostView(viewModel: storeViewModel, tabIndex: $tabIndex, selectedType: $selectedType)
            }
        }
    }
}

#Preview {
    PostView(tabIndex: .constant(1))
}
