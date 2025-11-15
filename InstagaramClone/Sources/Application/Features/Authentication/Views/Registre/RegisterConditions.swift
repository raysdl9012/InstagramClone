//
//  RegisterConditions.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct RegisterConditions: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack() {
            CustomBackButton() {
                dismiss()
            }
            ScrollView{
                Image("terms")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .padding(.bottom, 20)
                    .clipped()
                    .background(.clear)
                    .cornerRadius(14)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.3),lineWidth: 1.5)
                    }
                
                VStack(alignment: .leading) {
                    Text("To sign up, you must agree to our Terms.")
                        .font(Font.title2.bold())
                        .padding(.vertical, 10)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ulla ")
                }
                
                Spacer(minLength: 80)
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .scaleEffect(1.6)
                        .padding(.top, 30)
                } else {
                    CustomButtonRegister(title: "I Agree",
                                         isDisable: false) {
                        viewModel.register()
                    }.padding(.top, 30)
                }
                
            }
            .alert("Error de Registro", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            }, message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            })
            // Navegar automáticamente si el registro es exitoso
            .onChange(of: viewModel.registrationSuccess) { success in
                if success {
                    dismiss() // Cierra esta vista, el SessionManager ya actualizó la UI principal
                }
            }
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    NavigationStack{
        RegisterConditions()
            .environmentObject(AuthenticationViewModel())
    }
}
