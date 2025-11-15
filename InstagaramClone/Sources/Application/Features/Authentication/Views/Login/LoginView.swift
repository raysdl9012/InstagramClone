//
//  LoginView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .mask(
                        Circle()
                    )
                    .padding(10)
                    .background(.black)
                    .clipShape(Circle())
                    .clipped()
                    .padding(.bottom, 40)
                
                CustomTextFieldRegister(type: .text,
                                        placeholder:
                                            "Enter your email",
                                        text: $viewModel.email)
                
                CustomTextFieldRegister(type: .password,
                                        placeholder:
                                            "Enter your password",
                                        text: $viewModel.password)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .scaleEffect(1.6)
                        .padding(.top, 30)
                } else {
                    CustomButtonRegister(title: "Sing In",
                                         isDisable: emailIsValid || passwordIsValid,
                                         secondary: true) {
                        self.hideKeyboard()
                        viewModel.signIn()
                    }.padding(.top, 20)
                }
                
                Spacer()
                
                NavigationButton(text: "Create an account", isDisable: false) {
                    RegisterView()
                        .navigationBarBackButtonHidden(true)
                }
                
            }
            .padding(15)
            .alert("Error de Registro", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            }, message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            })
        }
    }
    
    
}

extension LoginView {
    private var emailIsValid: Bool {
        viewModel.email.isEmpty || !viewModel.email.contains("@") || !viewModel.email.contains(".")
    }
    private var passwordIsValid: Bool {
        viewModel.password.isEmpty || viewModel.password.count < 6
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionManager())
        .environmentObject(AuthenticationViewModel())
}
