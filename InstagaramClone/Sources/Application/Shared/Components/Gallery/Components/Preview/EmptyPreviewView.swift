//
//  EmptyStateView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Selecciona una foto o video")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Toca una imagen de tu galería")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    EmptyStateView()
}
