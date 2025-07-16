//
//  Boxes.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct Messages: View {
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("Messages")
                    .resizable()
                    .frame(width: 140, height: 24)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 40)
            
            
            List {
                Spacer()
                    .frame(height: 20)
                
                ForEach(0...10, id: \.self) { message in
                    MessageRow()
                    
                }
            }
            .listStyle(PlainListStyle())
            .frame(height: UIScreen.main.bounds.height - 120)
        }
    }
}

#Preview {
    Messages()
}
