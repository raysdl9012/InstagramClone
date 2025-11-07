//
//  PostCardInteractiveView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardInteractiveView: View {
    let username: String = "Sevens"
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                print("Like post de \(username)")
            }) {
                Image(systemName: "heart")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Button(action: {
                print("Comentar post de \(username)")
            }) {
                Image(systemName: "message")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Button(action: {
                print("Compartir post de \(username)")
            }) {
                Image(systemName: "paperplane")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Spacer() // Empuja el botón de guardar a la derecha
            Button(action: {
                print("Guardar post de \(username)")
            }) {
                Image(systemName: "bookmark")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    PostCardInteractiveView()
}
