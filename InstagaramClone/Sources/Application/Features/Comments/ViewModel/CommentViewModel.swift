//
//  CommentViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 14/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

class CommentViewModel: ObservableObject {
    
    private let databaseService: FIRDatabaseServiceProtocol
    @Published var comments: [CommentEntity] = []
    @Published var isLoadingComments = false
    @Published var errorMessage: String?
    @Published var newCommentText = ""
    
    init(databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared) {
        self.databaseService = databaseService
        
    }
    
    func fetchComments(forPostWithId postId: UUID)  {
        Task {
            do {
                let comments = try await databaseService.fetchComments(forPostID: postId.uuidString)
                await MainActor.run {
                    self.comments = comments
                }
            } catch {
                self.errorMessage = "Error al cargar los comentarios"
            }
        }
    }
    
    func postComment(userPost: UserEntity, postId: UUID) {
        guard !newCommentText.isEmpty, let media = userPost.profileImage else {
            self.errorMessage = "Error al publicar el comentario"
            return
        }
        
        Task {
            do {
                await MainActor.run {
                    self.isLoadingComments = false
                }
                
                let newComment = CommentEntity(ownerId: userPost.id,
                                               name: userPost.name,
                                               message: newCommentText.trimmingCharacters(in: .whitespacesAndNewlines),
                                               media: media,
                                               postId: postId)
                
                try await databaseService.addComment(newComment)
                self.comments.append(newComment)
                await MainActor.run {
                    self.isLoadingComments = true
                    self.newCommentText = ""
                }
                
            } catch {
                self.errorMessage = "Error al publicar el comentario: \(error.localizedDescription)"
            }
        }
    }
}
