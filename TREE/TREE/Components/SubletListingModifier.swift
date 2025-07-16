//
//  SubletListingView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct SubletListingModifier: View {
    let sublet: Sublets
    
    var body: some View {
        VStack(spacing: 8) {
            // images
            TabView {
                ForEach(sublet.imageURLs, id: \.self) { image in
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
    SubletListingModifier(sublet: DeveloperPreview.shared.sublets[0])
}
