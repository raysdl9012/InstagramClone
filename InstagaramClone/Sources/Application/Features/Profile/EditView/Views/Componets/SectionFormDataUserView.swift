//
//  SectionFormDataUserView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct SectionFormDataUserView: View {
    @Binding var isLoading: Bool
    @Binding var name: String
    @Binding var lastName: String
    @Binding var bio: String
    
    var onClick: () -> Void = { }
    
    var body: some View {
        Section("Personal information") {
            CustomTextFieldRegister(type: .text,
                                    placeholder: "Enter your name",
                                    text: $name)
            
            CustomTextFieldRegister(type: .text,
                                    placeholder: "Enter your lastName",
                                    text: $lastName)
            
            CustomTextEditView(text: $bio)
            
            Spacer()
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView("Guardando cambios...")
                        .padding()
                        .background(.clear)
                        .foregroundStyle(.purple)
                        .tint(Color.purple)
                        .cornerRadius(10)
                    Spacer()
                }
                
            }else {
                CustomButtonRegister(title: "Update",
                                     isDisable: false,
                                     secondary: true) {
                    onClick()
                    self.hideKeyboard()
                    
                }.padding(.top, 20)
            }
        }
    }
}

#Preview {
    SectionFormDataUserView(isLoading: .constant(false),
                            name: .constant("Reiiner"),
                            lastName: .constant("Daza"),
                            bio: .constant("Developer"))
}
