//
//  PostCardInteractiveView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardInteractiveView: View {
    
    let post: PostEntity
    let userLike: Bool
    var onLike: () -> Void = { }
    var onComment: () -> Void = { }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                onLike()
            }) {
                if userLike {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .font(.title2)
                        .foregroundColor(.red)
                }else {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            Button(action: {
                onComment()
            }) {
                Image(systemName: "message")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Button(action: {
                
            }) {
                Image(systemName: "paperplane")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Spacer() // Empuja el botón de guardar a la derecha
            Button(action: {
                
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
    PostCardInteractiveView(post: PostEntity.mock[0], userLike: true)
}
