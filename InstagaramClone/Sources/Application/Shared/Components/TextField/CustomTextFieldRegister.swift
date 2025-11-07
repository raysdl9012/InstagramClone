//
//  CustomTextFieldRegister.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI


enum TextFieldType {
    case text
    case password
}

struct CustomTextFieldRegister: View {
    
    var type: TextFieldType = .text
    var placeholder = "Email"
    @State private var showPassword: Bool = false
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack{
            if type == .password && !showPassword {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(focused: _isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(focused: _isFocused)
            }
            
            if type == .password{
                Image(systemName: "eye.slash")
                    .font(Font.system(size: 18))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        showPassword.toggle()
                    }
            }
        }
    }
}

#Preview {
    CustomTextFieldRegister(type: .password,
                            placeholder: "Password",
                            text: .constant("asdfas")).padding(10)
}
