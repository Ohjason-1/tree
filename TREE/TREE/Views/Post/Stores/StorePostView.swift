//
//  StorePostView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import SwiftUI

struct StorePostView: View {
    @ObservedObject var viewModel: StoresViewModel
    let productType = ["Microwave", "Television", "Shoes", "Sofa", "Chair", "Desk", "Others"]
    @Binding var tabIndex: Int
    private var isFormValid: Bool {
        return viewModel.price >= 0 &&
        !viewModel.title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.address.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.state.trimmingCharacters(in: .whitespaces).isEmpty && !viewModel.zipcode.trimmingCharacters(in: .whitespaces).isEmpty
    }
    @State private var shouldNavigateToPhotos = false
    @Binding var selectedType: PostDropDownMenuView.TreeType
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                HStack {
                    Button {
                        clearStorePostDataAndReturnToFeed()
                    } label: {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    PostDropDownMenuView(selectedType: $selectedType)
                    
                    Spacer()
                    
                    Button {
                        shouldNavigateToPhotos = true
                    } label: {
                        Text("Next")
                            .fontWeight(.semibold)
                    }
                    .disabled(!isFormValid)
                    .navigationDestination(isPresented: $shouldNavigateToPhotos) {
                        StorePhotoPostView(viewModel: viewModel, tabIndex: $tabIndex, shouldNavigateToPhotos: $shouldNavigateToPhotos)
                            .navigationBarBackButtonHidden()
                    }

                }
                .padding()
                
                Divider()
                
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
                                .frame(width: geometry.size.width * 0.5, height: 4)
                        }
                        
                }
                .padding(.vertical)
                .padding(.horizontal, 24)
                
                
                
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Product Details
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "storefront")
                                .foregroundStyle(Color("AccentColor").gradient)
                            
                            Text("Product Details")
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                        Text("Tell us about your product")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // price and productname
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Price ($) \(Text("*").foregroundColor(.red))")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            TextField("Used products should be cheaper!", value: $viewModel.price, formatter: NumberFormatter())
                                .modifier(PostModifier())
                                .keyboardType(.numberPad)
                        }
                        
                        Spacer()
                            .frame(width: 16)
                        
                        VStack(alignment: .leading) {
                            Text("Product Name \(Text("*").foregroundColor(.red))")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: productType, selected: $viewModel.productName)
                                .frame(height: 48)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Title \(Text("*").foregroundColor(.red))")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Spacious work desk", text: $viewModel.title)
                            .modifier(PostModifier())
                    }
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Description \(Text("*").foregroundColor(.red))")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("The price is negotiable~", text: $viewModel.description, axis: .vertical)
                            .modifier(PostModifier())
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    // MARK: - Location
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "location")
                                    .foregroundStyle(Color("AccentColor").gradient)
                                
                                Text("Location")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            
                            Text("Where is your property located?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Street Address \(Text("*").foregroundColor(.red))")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            TextField("123 Main Street", text: $viewModel.address)
                                .modifier(PostModifier())
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("City \(Text("*").foregroundColor(.red))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                TextField("City", text: $viewModel.city)
                                    .modifier(PostModifier())
                            }
                            
                            Spacer()
                                .frame(width: 16)
                            
                            VStack(alignment: .leading) {
                                Text("State \(Text("*").foregroundColor(.red))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                TextField("State", text: $viewModel.state)
                                    .modifier(PostModifier())
                            }
                            
                            Spacer()
                                .frame(width: 16)
                            
                            VStack(alignment: .leading) {
                                Text("zip code \(Text("*").foregroundColor(.red))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                TextField("zip code", text: $viewModel.zipcode)
                                    .modifier(PostModifier())
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
            }
        }
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
    StorePostView(viewModel: StoresViewModel(), tabIndex: .constant(1), selectedType: .constant(.stores))
}
