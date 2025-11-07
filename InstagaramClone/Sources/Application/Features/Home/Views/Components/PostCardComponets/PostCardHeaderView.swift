//
//  PostCardHeaderView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardHeaderView: View {
    var username: String = "@rsdl"
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill") // Icono de perfil genérico
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            Text(username)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    PostCardHeaderView()
}
