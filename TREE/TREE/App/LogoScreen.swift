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
            
            Image("App")
                .resizable()
                .frame(width:150, height: 150)
            
            Spacer()
            
            Image("TREE")
                .resizable()
                .frame(width:60, height: 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color("Background"))
    }
}

#Preview {
    LogoScreen()
}
