//
//  PostPictureView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/23/25.
//

import SwiftUI

struct SubletPostView: View {
    @ObservedObject var viewModel: SubletsViewModel
    let propertyTypes = ["Shared", "Not Shared"]
    var sharedBinding: Binding<String> {
            Binding(
                get: { viewModel.shared ? "Shared" : "Not Shared" },
                set: { newValue in
                    viewModel.shared = (newValue == "Shared")
                }
            )
        }
    let bedandBaths = ["0", "1", "2", "3", "4+"]
    @Binding var tabIndex: Int
    private var isFormValid: Bool {
        return viewModel.rentFee >= 0 &&
               !viewModel.address.trimmingCharacters(in: .whitespaces).isEmpty &&
               !viewModel.city.trimmingCharacters(in: .whitespaces).isEmpty &&
               !viewModel.state.trimmingCharacters(in: .whitespaces).isEmpty && !viewModel.zipcode.trimmingCharacters(in: .whitespaces).isEmpty &&
               viewModel.leaseStartDate < viewModel.leaseEndDate
    }
    @State private var shouldNavigateToPhotos = false
    @Binding var selectedType: PostDropDownMenuView.TreeType
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Button {
                        clearSubletPostDataAndReturnToFeed()
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
                        SubletPhotoPostView(viewModel: viewModel, tabIndex: $tabIndex, shouldNavigateToPhotos: $shouldNavigateToPhotos)
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
                    Text("For your second picture, make sure your name and the date are clearly displayed.")
                        .font(.caption)
                        .foregroundStyle(.green.gradient)
                    // MARK: - Property Details
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "house")
                                .foregroundStyle(Color("AccentColor").gradient)
                            
                            Text("Property Details")
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                        Text("Tell us about your place")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                        // property, bed, baths dropdownmenus
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rent Fee ($) \(Text("*").foregroundColor(.red))")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            TextField("$1,500", value: $viewModel.rentFee, formatter: NumberFormatter())
                                .modifier(PostModifier())
                                .keyboardType(.numberPad)
                        }
                        
                        Spacer()
                            .frame(width: 16)
                        
                        VStack(alignment: .leading) {
                            Text("Property Type \(Text("*").foregroundColor(.red))")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: propertyTypes, selected: sharedBinding, wantBlack: false)
                                .frame(height: 48)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bedrooms")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: bedandBaths, selected: $viewModel.numberOfBedrooms, wantBlack: false)
                                .frame(height: 48)
                        }
                        
                        Spacer()
                            .frame(width: 16)
                        
                        VStack(alignment: .leading) {
                            Text("Bathrooms")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: bedandBaths, selected: $viewModel.numberOfBathrooms, wantBlack: false)
                                .frame(height: 48)
                        }
                        
                    }
                    
                    // Start Date
                    DatePicker("Lease Start Date \(Text("*").foregroundColor(.red))", selection: $viewModel.leaseStartDate, displayedComponents: .date)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .modifier(PostModifier())
                    
                    DatePicker("Lease End Date \(Text("*").foregroundColor(.red))", selection: $viewModel.leaseEndDate, displayedComponents: .date)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .modifier(PostModifier())
                    
                    
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
                                Text("State \(Text("*").foregroundColor(.red))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                DropDownPost(menus: LocationData.allStates, selected: $viewModel.state, wantBlack: false)
                                    .frame(height: 48)
                                
                            }
                            
                            Spacer()
                                .frame(width: 16)
                            
                            VStack(alignment: .leading) {
                                Text("City \(Text("*").foregroundColor(.red))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                DropDownPost(menus: LocationData.cities(for: viewModel.state), selected: $viewModel.city, wantBlack: false)
                                    .frame(height: 48)
                                    .foregroundStyle(.black)
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
                    
                    Spacer()
                        .frame(height: 16)
                    
                    
                    // MARK: - Description
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil.line")
                                    .foregroundStyle(Color("AccentColor").gradient)
                                
                                Text("Feed")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            
                            Text("Write a title and description for your feed!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Title")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("1BD 1Bath Cozy Place!", text: $viewModel.title)
                            .modifier(PostModifier())
                    }
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("The rent fee is negotiable~!", text: $viewModel.description, axis: .vertical)
                            .modifier(PostModifier())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
            }
        }
        
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
    // Preview with a minimal DI container
    let profile = ProfileViewModel()
    let subletsVM = SubletsViewModel(profile: profile)
    SubletPostView(viewModel: subletsVM, tabIndex: .constant(0), selectedType: .constant(.sublets))
}
