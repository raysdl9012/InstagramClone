//
//  CameraButtonView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CameraButtonView: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onTap()
        }) {
            ZStack {
                Color.gray.opacity(0.2)
                    .aspectRatio(1, contentMode: .fill)
                
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                    
                    Text("Cámara")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

#Preview {
    CameraButtonView() {
        
    }
}
