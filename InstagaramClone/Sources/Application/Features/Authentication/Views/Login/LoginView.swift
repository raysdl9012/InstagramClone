//
//  LoginView
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var session: SessionManager
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    
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
                                        text: $emailText)
                
                
                CustomTextFieldRegister(type: .password,
                                        placeholder:
                                            "Enter your password",
                                        text: $emailText)
 
                CustomButtonRegister(title: "Sing In", isDisable: false, secondary: true) {
                    session.login()
                }.padding(.top, 20)
 
                
                
                Spacer()
                
                NavigationButton(text: "Create an account", isDisable: false) {
                    RegisterView()
                        .navigationBarBackButtonHidden(true)
                }
                
            }.padding(15)
        }
    }
}

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    func login() {
        // Aquí podrías validar credenciales o llamar tu API
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
    }
}


#Preview {
    LoginView()
}
