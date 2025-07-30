//
//  StoreListingDetailView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/16/25.
//

import SwiftUI

struct StoreListingDetailView: View {
    let store: Stores
    @State private var chatUser: Users?
    @State private var showingChat = false
    
    var body: some View {
        ScrollView {
            TreeListingModifier(tree: store)
                .frame(height: 320)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(store.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .background(.primary)
                // with required info like number of baths and bds, AI can write this down
                Text("\(store.description)")
                    .font(.subheadline)
                
                
                Divider()
                    .background(.primary)
                Group {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(store.address), \(store.city), \(store.state)")
                            Text("\(store.zipcode)")
                        }
                        
                        Spacer()
                        
                        CircularProfileImageView(userImageUrl: store.ownerImageUrl, size: .small)

                    }
                    .font(.footnote)
                    
                    
                    
                    Text("$ **\(store.price)**")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("Color").opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    
                    Button {
                        UserService.fetchUser(withUid: store.ownerUid) { user in
                            DispatchQueue.main.async {
                                self.chatUser = user
                                self.showingChat = true
                            }
                        }
                    } label: {
                        Text("Chat with Renter !")
                            .font(.subheadline)
                            .foregroundStyle(Color("AccentColor"))
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 32)
                            .foregroundStyle(Color(UIColor.label))
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("AccentColor"), lineWidth: 1)
                            }
                    }
                    .disabled(UserInfo.currentUserId == store.ownerUid)
                    .navigationDestination(isPresented: $showingChat) {
                        if let user = chatUser {
                            ChatView(user: user)
                        }
                    }
                    
                    
                }
                .padding(.horizontal, 8)
            }
            .padding()
        }
    }
}

#Preview {
    StoreListingDetailView(store: DeveloperPreview.shared.stores[0])
}
