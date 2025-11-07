//
//  RegisterView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI


struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var emailText = ""
    
    var body: some View {
        SkeletonRegister(title: "Whats your email?",
                         description: "Enter the email you wish to use to create an account") {
            CustomTextFieldRegister(placeholder: "Email",
                                    text: $emailText)
            
            NavigationButton(text: "Next",
                             isDisable: emailIsValid) {
                RegisterCode()
                    .navigationBarBackButtonHidden(true)
            }
        }
        footer: {
            CustomButtonHaveAccount() {
                dismiss()
            }
        } onBack: {
            dismiss()
        }
    }
}

extension RegisterView {
    private var emailIsValid: Bool {
        emailText.isEmpty || !emailText.contains("@")
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
