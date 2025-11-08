//
//  PostCardView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardView: View {
    
    var post: PostEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            // MARK: - Encabezado del Post (Usuario y Opciones)
            PostCardHeaderView(username: post.userName)
            
            // MARK: - Imagen del Post
            PostCardMultimediaView(media: post.media)
            
            // MARK: - Botones de Interacción
            PostCardInteractiveView()
            
            // MARK: - Likes y Descripción
            PostCardInfoView(post: post)
        }
        .background(Color.clear)
    }
}

#Preview {
    PostCardView(post: PostEntity.mock.first!)
}
