//
//  CommentsView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 14/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import UIKit


import SwiftUI

struct CommentsView: View {
    
    @Environment(\.dismiss) var dismiss

    var postId: UUID
    var author: UserEntity
    
    var onUpdate: () -> Void = {}
    
    @EnvironmentObject private var viewModel: CommentViewModel

    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    ForEach(viewModel.comments) { comment in
                        CommentsMessageView(userName: comment.name,
                                            comment: comment.message,
                                            media: comment.media)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                MessageSendView(media: author.profileImage!,
                                message: $viewModel.newCommentText) {
                    hideKeyboard()
                    viewModel.postComment(userPost: author,
                                          postId: postId)
                }
            }
            .onChange(of: viewModel.isLoadingComments) { newItem in
                if !newItem {
                    viewModel.fetchComments(forPostWithId: postId)
                }
            }
             
            .task {
                if viewModel.comments.isEmpty{
                    viewModel.fetchComments(forPostWithId: postId)
                }
            }
            .padding(.bottom)
        }
    }
}

struct CommentsView2: View {
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var sessionManager: SessionManager
    @FocusState private var isTextFieldFocused: Bool
    
    var post: PostEntity
    var author: UserEntity
    @StateObject private var viewModel =  CommentViewModel()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ScrollView {
                ForEach(CommentEntity.mock) { comment in
                    CommentsMessageView(userName: comment.name,
                                        comment: comment.message,
                                        media: comment.media)
                }
            }
            .frame(height: UIScreen.screenHeight * 0.60)
            .padding(.top, 50)
            
            Spacer()
            
            MessageSendView(media: (sessionManager.currentUser?.profileImage)!,
                            message: $viewModel.newCommentText) {
                
                viewModel.postComment(userPost: sessionManager.currentUser!,
                                      postId: post.id)
                
                
            }.padding(.bottom, 20)
        
        }
    }
}

#Preview {
    
    CommentsView(postId: PostEntity.mock[0].id, author: UserEntity.mock)
        .environmentObject(CommentViewModel())
    
    
}
