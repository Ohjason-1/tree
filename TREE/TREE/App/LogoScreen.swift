//
//  LogoScreen.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct LogoScreen: View {
    var body: some View {
        ZStack {
            Image("LogoScreenBackground")
                .resizable()
                .scaledToFill()   // make it cover the whole screen
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image("AppIconWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width:64)
                    .padding(.leading, 7)
                    .padding(.top, 52)
                
                Spacer()
                Text("TREE")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(.bottom, 38)
                    .padding(.leading, 3)
            }
        }
    }
}

#Preview {
    LogoScreen()
}
