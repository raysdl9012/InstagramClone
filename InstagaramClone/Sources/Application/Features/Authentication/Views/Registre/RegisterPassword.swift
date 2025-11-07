//
//  RegisterPassword.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct RegisterPassword: View {
    @Environment(\.dismiss) var dismiss
    @State var passwordText: String = ""
    
    var body: some View {
        SkeletonRegister(title: "Create a password",
                         description: "Create a password with at least 6 letters or numbers. It should not contain spaces or emojis.") {
            
            CustomTextFieldRegister(type: .password,
                                    placeholder: "Password",
                                    text: $passwordText)
            
            NavigationButton(text: "Next",
                             isDisable: passwordIsValid) {
                RegisterName()
                    .navigationBarBackButtonHidden(true)
            }
        }
        onBack: {
            dismiss()
        }
    }
}

extension RegisterPassword {
    private var passwordIsValid: Bool {
        passwordText.isEmpty || passwordText.count < 6
    }
}

#Preview {
    NavigationStack {
        RegisterPassword()
    }
}
