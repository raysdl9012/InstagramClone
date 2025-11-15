//
//  HomeViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseFirestore
internal import Combine

class HomeViewModel: ObservableObject {
    
    private let databaseService: FIRDatabaseServiceProtocol
    
    @Published var posts: [PostEntity] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    @Published var authors: [String: UserEntity] = [:]
    
    
    private var authorIDs: Set<String> = []
    
    // Pagination
    private let pageSize = 10
    private var lastDocument: DocumentSnapshot?
    
    
    init(databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared) {
        self.databaseService = databaseService
    }
    
    /// Carga el primer lote de posts. Se usa para refrescar el feed.
    func fetchPosts() {
        guard !isLoading else { return }
        
        
        Task {
            do {
                
                await MainActor.run {
                    isLoading = true
                    errorMessage = nil
                }
                
                // Reiniciamos el estado de paginación
                lastDocument = nil
                let (newPosts, newLastDocument) = try await databaseService.fetchPosts(limit: pageSize, startAfter: lastDocument)
                
                let authorIds = Set(newPosts.map { $0.ownerId })
                authorIDs = authorIDs.union(authorIds)
                
                await loadAutorsFromPost(authorIDs: authorIDs)
                
                await MainActor.run {
                    self.posts = newPosts
                    self.lastDocument = newLastDocument
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error al cargar más posts: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    /// Carga el siguiente lote de posts (paginación).
    func loadMorePosts() {
        guard !isLoadingMore, lastDocument != nil else { return }
        isLoadingMore = true
        Task {
            do {
                let (newPosts, newLastDocument) = try await databaseService.fetchPosts(limit: pageSize, startAfter: lastDocument)
                let authorIds = Set(newPosts.map { $0.ownerId })
                authorIDs = authorIDs.union(authorIds)
                await loadAutorsFromPost(authorIDs: authorIDs)
                await MainActor.run {
                    self.posts.append(contentsOf: newPosts)
                    self.lastDocument = newLastDocument
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error al cargar más posts: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.isLoadingMore = false
            }
        }
    }
    
    private func loadAutorsFromPost(authorIDs: Set<String> ) async {
        do {
            let authorTuples = try await withThrowingTaskGroup(of: (String, UserEntity).self) { group in
                for id in authorIDs {
                    group.addTask { [self] in
                        let user = try await databaseService.fetchUser(id: id)
                        return (id, user)
                    }
                }
                return try await group.reduce(into: []) { $0.append($1) }
            }
            await MainActor.run {
                self.authors = Dictionary(uniqueKeysWithValues: authorTuples)
            }
            
        } catch {
            Logger.log(.firebase, message: "Error load users from posts: \(error.localizedDescription)")
        }
        
    }
    
    func fetchUserByID(_ userID: String) async -> UserEntity? {
        return try? await self.databaseService.fetchUser(id: userID)
    }
    
    func updatePostBy(like userId:String, post: PostEntity) async {
        var likes: [String] = post.likes
        if likes.contains(userId){
            likes = likes.filter({$0 != userId})
        }else {
            likes.append(userId)
        }
        var newPost = post
        newPost.likes = likes
        try? await self.databaseService.updatePost(newPost)
        fetchPosts()
    }
}
