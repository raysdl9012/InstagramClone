//
//  PostCardView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var viewModelComments: CommentViewModel

    var post: PostEntity
    
    @State private var isCommentSheetPresented: Bool = false
    
    private var userLike: Bool {
        post.likes.contains(sessionManager.currentUser?.id ?? "")
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            // MARK: - Encabezado del Post (Usuario y Opciones)
            PostCardHeaderView(post: post)
            
            // MARK: - Imagen del Post
            PostCardMultimediaView(media: post.media)
            
            // MARK: - Botones de Interacción
            PostCardInteractiveView(post: post,
                                    userLike: userLike,
                                    onLike: {
                Task {
                    await viewModel.updatePostBy(like: sessionManager.currentUser?.id ?? "",
                                                 post: post)
                }
            },
                                    onComment: {
                isCommentSheetPresented = true
            })
            // MARK: - Likes y Descripción
            PostCardInfoView(post: post)
        }
        
        .sheet(isPresented: $isCommentSheetPresented) {
            CommentsView(postId: post.id, author: sessionManager.currentUser!)
                .environmentObject(viewModelComments)
        }
        
    }
}

#Preview {
    PostCardView(post: PostEntity.mock[1])
        .environmentObject(VideoControlViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SessionManager())
        .environmentObject(CommentViewModel())
    
}
