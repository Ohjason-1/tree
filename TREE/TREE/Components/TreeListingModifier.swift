//
//  SubletListingView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct TreeListingModifier: View {
    let tree: any Tree
    
    var body: some View {
        VStack(spacing: 8) {
            // images
            TabView {
                ForEach(tree.imageURLs, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .tabViewStyle(.page)
        }
    }
}

#Preview {
    TreeListingModifier(tree: DeveloperPreview.shared.sublets[0])
}
