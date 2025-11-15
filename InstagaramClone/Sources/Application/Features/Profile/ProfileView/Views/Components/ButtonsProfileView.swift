//
//  ButtonsProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI


struct ButtonsProfileView: View {
    
    var onEdit: () -> Void = { }
    var onShare: () -> Void = { }
    
    var body: some View {
        // Botones de Acción
        HStack(spacing: 15) {
            Button(action: {
                onEdit()
            }) {
                Text("Edit Profile")
                    .primaryButtonStyleProfie()
            }
            Button(action: {
                onShare()
            }) {
                Text("Share Profile") // Texto del botón
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
