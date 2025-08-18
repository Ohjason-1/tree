//
//  isUploadingView.swift
//  TREE
//
//  Created by Jaewon Oh on 8/17/25.
//

import SwiftUI

struct isUploadingView: View {
    @State private var rotate = false
        var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Text("Processing...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("AccentColor").gradient)
                
                Image("Rotating")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false), value: rotate)
                    
            }
            .onAppear { rotate.toggle() }
        }
}

#Preview {
    isUploadingView()
}
