//
//  SearchAndFilterBar.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct SearchAndFilterBar: View {
    
    var body: some View {
        HStack {
            VStack {
                Text("Berkeley,")
                Text("California")
            }
            .font(.system(size: 20))
            .fontWeight(.bold)
            
            
            Spacer()
            
            HStack {
                // dropdown menu for locations
                Text("Location")
                
                Divider()
                
                Text("Put your Location")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(height:50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
            }
        }
        .foregroundStyle(Color("AccentColor"))
    }
}

#Preview {
    SearchAndFilterBar()
}
