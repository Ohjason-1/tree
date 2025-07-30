//
//  CircularProfileImageView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import SwiftUI
import Kingfisher

enum Size {
    case xSmall
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case .xSmall: return 28
        case .small: return 56
        case .medium: return 80
        case .large: return 100
        }
    }
}

struct CircularProfileImageView: View {
    let userImageUrl: String?
    let size: Size
    
    var body: some View {
        if let image = userImageUrl {
            KFImage(URL(string: image))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(.circle)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color(.systemGray))
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(.circle)
        }
        
    }
}

#Preview {
    CircularProfileImageView(userImageUrl: "Profile", size: .xSmall)
}
