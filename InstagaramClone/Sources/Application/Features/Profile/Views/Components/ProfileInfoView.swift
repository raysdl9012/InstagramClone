//
//  ProfileInfoView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ProfileInfoView: View {
    var body: some View {
        // Biografía
        VStack(alignment: .leading, spacing: 5) {
            Text("Juan Pérez")
                .font(.headline)
            Text("Desarrollador iOS | Aprendiz de SwiftUI 🚀 | Creando apps increíbles.")
                .font(.body)
            
            Text("enlace-a-mi-web.com")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

#Preview {
    ProfileInfoView()
}
