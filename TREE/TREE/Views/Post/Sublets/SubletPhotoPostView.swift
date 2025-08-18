//
//  SubletPhotoPostView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/23/25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SubletPhotoPostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SubletsViewModel
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
                
                Text("New Sublet")
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    Task {
                        isUploading = true
                        do {
                            try await viewModel.uploadSublet()
                            clearSubletPostDataAndReturnToFeed()
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
            
            Divider()
            
            //MARK: - capsule showing progress
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
            
            
            // MARK: - sublet info preview
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
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
                        
                    }
                    .font(.footnote)
                    
                    
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "bed.double")
                            
                            Text("**\(viewModel.numberOfBedrooms)** bedrooms")
                        }
                        
                        HStack {
                            Image(systemName: "bathtub")
                            
                            Text("**\(viewModel.numberOfBathrooms)** bathrooms")
                                
                        }
                        
                        Spacer()
                        
                        Text(viewModel.shared ? "Shared \(Image(systemName: "person.2.fill"))" : "Not shared \(Image(systemName: "person.fill"))")
                        
                    }
                    .font(.footnote)
                    
                    Text("$ **\(viewModel.rentFee)** /month")
                        .foregroundStyle(Color("AccentColor"))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("Color").opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "calendar")
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lease Term")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Text("**Start**: \(viewModel.leaseStartDate.formatted(date: .abbreviated, time: .omitted))")
                                Spacer()
                                Text("**End**: \(viewModel.leaseEndDate.formatted(date: .abbreviated, time: .omitted))")
                                    
                            }
                            .font(.footnote)
                            .padding(.trailing, 20)
                        }
                    }
                    .frame(height: 80)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.secondary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    Text("Cheap Furnitures !")
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
        .photosPicker(isPresented: $imagePresented, selection: $viewModel.selectedImage, maxSelectionCount: 10, matching: .images)
    }
    
    func clearSubletPostDataAndReturnToFeed() {
        viewModel.numberOfBedrooms = ""
        viewModel.numberOfBathrooms = ""
        viewModel.zipcode = ""
        viewModel.images = []
        viewModel.address = ""
        viewModel.city = ""
        viewModel.state = ""
        viewModel.shared = false
        viewModel.leaseStartDate = Date()
        viewModel.leaseEndDate = Date()
        viewModel.rentFee = 0
        viewModel.title = ""
        viewModel.description = ""
        
        tabIndex = 0
        shouldNavigateToPhotos = false
    }
}




#Preview {
    let profile = ProfileViewModel()
    let subletsVM = SubletsViewModel(profile: profile)
    SubletPhotoPostView(viewModel: subletsVM, tabIndex: .constant(0), shouldNavigateToPhotos: .constant(false))
}
