//
//  EmptyStateProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct EmptyStateProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Aún no tienes publicaciones")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Comparte tus momentos favoritos con tus amigos.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    EmptyStateProfileView()
}
