//
//  RegisterCodeConfirm.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct RegisterCode: View {
    @Environment(\.dismiss) var dismiss
    @State var code: [String] = Array(repeating: "", count: 5)
    @State var isCodeValidate: Bool = false
    
    var body: some View {
        SkeletonRegister(title: "Enter the confirmation code",
                         description: "To confirm your account, please enter the confirmation code we sent to your email") {
            
            CustomTextFieldCode(code: $code)
            
            if isCodeValidate && codeIsValid {
                Text("Invalid code, Please try again.")
                    .font(Font.subheadline.bold())
                    .foregroundStyle(.red)
            }
            
            CustomButtonRegister(title: "Next",
                                 isDisable: codeIsValid) {
                isCodeValidate.toggle()
            }
        }
        onBack: {
            dismiss()
        }
        .navigationDestination(isPresented: $isCodeValidate) {
            RegisterPassword()
                .navigationBarBackButtonHidden(true)
        }
    }
}

extension RegisterCode {
    private var codeIsValid: Bool {
        !(code.joined().count == 5)
    }
}

#Preview {
    NavigationStack {
        RegisterCode()
    }
}
