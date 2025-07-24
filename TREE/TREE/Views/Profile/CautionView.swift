//
//  CautionView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/16/25.
//

import SwiftUI

struct CautionView: View {
    var body: some View {
        VStack(alignment: .leading) {
        
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Warning List")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Divider()
                    .background(.primary)
                
                Group {
                    Text("1. Verify Before You Meet Always confirm the person's identity and listing details before meeting in person. Ask for additional photos, proof of ownership, and verify their contact information matches the listing.")
                    
                    Text("2. Meet in Public First Schedule initial meetings in public places like coffee shops or community centers. Never go alone to view apartments or pick up furniture - bring a friend or family member with you.")
                    
                    Text("3. Trust Your Instincts If something feels wrong - whether it's pushy behavior, prices that seem too good to be true, or requests for personal information - don't proceed. Report suspicious users through the app immediately.")
                }
                .fontWeight(.semibold)
            }
            
            Spacer()
        }
    }
}

#Preview {
    CautionView()
}
