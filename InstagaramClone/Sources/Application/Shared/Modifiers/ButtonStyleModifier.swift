//
//  ButtonStyleModifier.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    var isDisable: Bool = false
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(10)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDisable
                                       ? [Color.gray.opacity(0.6), Color.gray.opacity(0.35)]
                                       : [Color.green.opacity(0.6), Color.blue.opacity(0.35)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(isDisable ? 0 : 0.2), radius: 6, y: 3)
            .contentShape(Rectangle())
            .disabled(isDisable)
            .opacity(isDisable ? 0.7 : 1.0)
            .scaleEffect(isDisable ? 1.0 : 0.995)
            .animation(.easeInOut(duration: 0.18), value: isDisable)
    }
}

struct SecondButtonStyleModifier: ViewModifier {
    var isDisable: Bool = false
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(10)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDisable
                                       ? [Color.gray.opacity(0.6), Color.gray.opacity(0.35)]
                                       : [Color.purple.opacity(0.6), Color.orange.opacity(0.35)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(isDisable ? 0 : 0.2), radius: 6, y: 3)
            .contentShape(Rectangle())
            .disabled(isDisable)
            .opacity(isDisable ? 0.7 : 1.0)
            .scaleEffect(isDisable ? 1.0 : 0.995)
            .animation(.easeInOut(duration: 0.18), value: isDisable)
    }
}
