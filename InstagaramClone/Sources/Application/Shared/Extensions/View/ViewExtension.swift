//
//  ViewExtension.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import SwiftUI

extension View {
    func primaryButtonStyle(isDisable: Bool = false, isSecondary: Bool = false) -> some View {
        self.modifier(ButtonStyleModifier(isDisable: isDisable))
    }
    
    func secondaryButtonStyle(isDisable: Bool = false, isSecondary: Bool = false) -> some View {
        self.modifier(SecondButtonStyleModifier(isDisable: isDisable))
    }
    
    func textFieldStyle(focused: FocusState<Bool>) -> some View {
        self.modifier(TextFieldStyleModifier(isFocused: focused) )
    }
    
    func primaryButtonStyleProfie() -> some View {
        self
            .font(.subheadline).bold()
            .foregroundColor(.purple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [
                        Color.green.opacity(0.6),
                        Color.orange.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(6)
    }
    func secondaryButtonStyleProfie() -> some View {
        self
            .font(.subheadline).bold()
            .foregroundColor(.purple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.6),
                        Color.purple.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(6)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
