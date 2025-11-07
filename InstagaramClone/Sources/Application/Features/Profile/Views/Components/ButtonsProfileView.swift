//
//  ButtonsProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI


struct ButtonsProfileView: View {
    
    var onFlow: () -> Void = { }
    var onShare: () -> Void = { }
    
    var body: some View {
        // Botones de Acción
        HStack(spacing: 15) {
            Button(action: {
                onShare()
            }) {
                Text("Share Profile")
                    .primaryButtonStyleProfie()
            }
            
            Button(action: {
                print("Enviar mensaje")
            }) {
                Text("Mensaje") // Texto del botón
                    .secondaryButtonStyleProfie()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
}

#Preview {
    ButtonsProfileView()
}
