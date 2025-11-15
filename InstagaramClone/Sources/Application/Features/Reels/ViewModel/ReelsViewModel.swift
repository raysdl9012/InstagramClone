//
//  ReelsViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseFirestore
internal import Combine

class ReelsViewModel: ObservableObject {
    
    private let databaseService: FIRDatabaseServiceProtocol
    
    @Published var reels: [ReelEntity] = []
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
    func fetchReels() {
        guard !isLoading else { return }
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                    errorMessage = nil
                }
                lastDocument = nil
                let (newReels, newLastDocument) = try await databaseService.fetchReels(limit: pageSize, startAfter: lastDocument)
                let authorIds = Set(newReels.map { $0.ownerId })
                authorIDs = authorIDs.union(authorIds)
                await loadAutorsFromReels(authorIDs: authorIDs)
                await MainActor.run {
                    self.reels = newReels
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
    func loadMoreReels() {
        guard !isLoadingMore, lastDocument != nil else { return }
        isLoadingMore = true
        Task {
            do {
                let (newReels, newLastDocument) = try await databaseService.fetchReels(limit: pageSize, startAfter: lastDocument)
                let authorIds = Set(newReels.map { $0.ownerId })
                authorIDs = authorIDs.union(authorIds)
                await loadAutorsFromReels(authorIDs: authorIDs)
                await MainActor.run {
                    self.reels.append(contentsOf: newReels)
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
    
    private func loadAutorsFromReels(authorIDs: Set<String> ) async {
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
    
    func updateReelsBy(like userId:String, reel: ReelEntity) async {
        var likes: [String] = reel.likes
        if likes.contains(userId){
            likes = likes.filter({$0 != userId})
        }else {
            likes.append(userId)
        }
        var newReel = reel
        newReel.likes = likes
        try? await self.databaseService.updateReel(newReel)
        fetchReels()
    }
}
