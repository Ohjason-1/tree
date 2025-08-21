//
//  label.swift
//  TREE
//
//  Created by Jaewon Oh on 8/19/25.
//

import SwiftUI

struct DropDownRegister: View {
    // MARK: - Variable
        private let textFieldHeight: CGFloat = 40
        private let placeHolderText: String
        @Binding private var text: String
        @FocusState private var isFieldFocused: Bool
        let leftIcon: String?
        let rightIcon: String?
        let isSecure: Bool
        private var shouldPlaceHolderMove: Bool {
            isFieldFocused || (text.count != 0)
        }
        
        // MARK: - init
        public init(placeHolder: String,
                    text: Binding<String>, leftIcon: String? = nil, rightIcon: String? = nil, isSecure: Bool = false) {
            self._text = text
            self.placeHolderText = placeHolder
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.isSecure = isSecure
        }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if text.isEmpty && !isFieldFocused {
                    Text(placeHolderText)
                        .font(.subheadline)
                        .foregroundColor(.black) // Your custom placeholder color
                }
                
                // Text Fied
                Group {
                    if isSecure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .focused($isFieldFocused)
                .toolbar {
                    if isFieldFocused {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isFieldFocused = false
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                            .padding(.trailing, 12)
                        }
                    }
                }
                .foregroundStyle(.black)
                .accentColor(.black) // cursor color
                .autocorrectionDisabled()
                .animation(Animation.easeInOut(duration: 0.2), value: EdgeInsets())
                .frame(alignment: .leading)
                
                
                // Right Icon
                if rightIcon != nil {
                    Image(systemName: rightIcon ?? "person")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("AccentColor").gradient)
                }
            }
            .padding(12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFieldFocused ? Color("Color").gradient : Color.black.gradient, lineWidth:  1.5)
            }
            
            // Floating Placeholder
            Text(isFieldFocused ? " " + placeHolderText + " " : "")
                .font(.caption)
                .foregroundColor(.black)
                .scaleEffect(shouldPlaceHolderMove ? 1.0 : 1.2)
                .animation(Animation.easeInOut(duration: 0.2), value: shouldPlaceHolderMove)
                .background(.white)
                .padding(shouldPlaceHolderMove ?
                         EdgeInsets(top: 0, leading: 15, bottom: textFieldHeight + 8, trailing: 0) :
                            EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
        }
        .frame(height: textFieldHeight)
    }
}

#Preview {
    DropDownRegister(placeHolder: "Name", text: .constant(""), rightIcon: "person.fill")
}
