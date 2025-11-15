//
//  RegisterView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI


struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        SkeletonRegister(title: "Whats your email?",
                         description: "Enter the email you wish to use to create an account") {
            
            CustomTextFieldRegister(placeholder: "Email",
                                    text: $viewModel.email)
            
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
        viewModel.email.isEmpty || !viewModel.email.contains("@") || !viewModel.email.contains(".")
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AuthenticationViewModel())
    }
}
