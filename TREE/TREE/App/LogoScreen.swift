//
//  LogoScreen.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct LogoScreen: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("Appicon")
                .resizable()
                .frame(width:70, height: 75)
            
            Spacer()
            
            Image("TREE")
                .resizable()
                .frame(width:70, height: 25)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LogoScreen()
}
