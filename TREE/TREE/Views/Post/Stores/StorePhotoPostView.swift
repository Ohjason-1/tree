//
//  StorePhotoView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import SwiftUI

struct StorePhotoPostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StoresViewModel
    @State private var imagePresented = false
    
    // After upload, navigate to home view w/ errors
    @Binding var tabIndex: Int
    @Binding var shouldNavigateToPhotos: Bool
    
    // error
    @State private var isUploading = false
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                Text("New Store")
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    Task {
                        isUploading = true
                        do {
                            try await viewModel.uploadStore()
                            clearStorePostDataAndReturnToFeed()
                        } catch {
                        }
                        isUploading = false
                    }
                } label: {
                    if isUploading {
                            isUploadingView()
                        } else {
                            Text("Upload")
                                .fontWeight(.semibold)
                        }
                }
                .disabled(viewModel.images.isEmpty || isUploading)
                .alert(isPresented: $viewModel.showingAlert) {
                    Alert(title: Text("Upload Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }

            }
            .padding()
            
            
            // capsule showing progress
            GeometryReader { geometry in
                Capsule()
                    .fill(.secondary.opacity(0.1))
                    .frame(height: 4)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(LinearGradient(
                                            colors: [Color("Color"), Color("AccentColor")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                            .frame(width: geometry.size.width * 0.95, height: 4)
                    }
                    
            }
            .padding(.vertical)
            .padding(.horizontal, 24)
            
            // MARK: - photopicker
            if !viewModel.images.isEmpty {
                TabView {
                    ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 320)
            } else {
                Rectangle()
                    .fill(.secondary)
                    .frame(height: 320)
                    .overlay {
                        Button {
                            imagePresented = true
                        } label: {
                            Image(systemName: "photo.badge.plus")
                                .font(.title)
                                .foregroundStyle(Color(UIColor.label))
                        }

                    }
                    
            }
            
            // MARK: - product info preview
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .background(.primary)
                // with required info like number of baths and bds, AI can write this down
                Text("\(viewModel.description)")
                    .font(.subheadline)
                
                
                Divider()
                    .background(.primary)
                Group {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(viewModel.address), \(viewModel.city), \(viewModel.state)")
                            Text("\(viewModel.zipcode)")
                        }
                        
                        CircularProfileImageView(user: DeveloperPreview.shared.user, size: .small)

                    }
                    .font(.footnote)
                    
                    
                    
                    Text("$ **\(viewModel.price)**")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("Color").opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text("Chat!")
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
                .padding(.horizontal, 8)
            }
            .padding()
        }
        .onAppear {
            imagePresented.toggle()
        }
        .photosPicker(isPresented: $imagePresented, selection: $viewModel.selectedImage, maxSelectionCount: 5, matching: .images)
    }
    func clearStorePostDataAndReturnToFeed() {
        viewModel.zipcode = ""
        viewModel.images = []
        viewModel.address = ""
        viewModel.city = ""
        viewModel.state = ""
        viewModel.price = 0
        viewModel.title = ""
        viewModel.description = ""
        viewModel.productName = "Microwave"
        
        tabIndex = 0
        shouldNavigateToPhotos = false
    }
}

#Preview {
    let profile = ProfileViewModel()
    let storesVM = StoresViewModel(profile: profile)
    StorePhotoPostView(viewModel: storesVM, tabIndex: .constant(1), shouldNavigateToPhotos: .constant(false))
}
