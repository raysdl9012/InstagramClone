//
//  RegisterName.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct RegisterName: View {
    @Environment(\.dismiss) var dismiss
    @State var nameText: String = ""
    
    var body: some View {
        SkeletonRegister(title: "What's your name?",
                         description: "Add your name to your profile") {
            
            CustomTextFieldRegister(placeholder: "Enter your name",
                                    text: $nameText)
            
            NavigationButton(text: "Next",
                             isDisable: nameText.count < 5) {
                RegisterBirthDay()
                    .navigationBarBackButtonHidden(true)
            }
        }
        onBack: {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack{
        RegisterName()
    }
}
