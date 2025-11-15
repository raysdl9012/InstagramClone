//
//  ProfileViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

import Foundation

class ProfileViewModel: ObservableObject {
    
    // Dependencias inyectadas
    private let databaseService: FIRDatabaseServiceProtocol
    
    // Propiedades publicadas para la vista
    @Published var userPosts: [PostEntity] = []
    @Published var isLoadingUserPosts = false
    @Published var userPostsError: String?
    
    init(databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared) {
        self.databaseService = databaseService
    }
    
    /// Carga los posts del usuario desde la base de datos.
    func fetchUserPosts(user: UserEntity?) {
        guard let currentUser = user else {
            userPostsError = "No hay un usuario autenticado."
            return
        }
        isLoadingUserPosts = true
        userPostsError = nil
        Task {
            do {
                let posts = try await databaseService.fetchPosts(forUserID: currentUser.id)
                await MainActor.run {
                    self.userPosts = posts
                }
            } catch {
                self.userPostsError = "Error al cargar los posts: \(error.localizedDescription)"
            }
            await MainActor.run {
                self.isLoadingUserPosts = false
            }
        }
    }
    
    public func updateProfileWithFollowers(id: String, to user: UserEntity, onComplete: @escaping (UserEntity) -> Void) async {
        var updatedFollowers: [String] = user.followers ?? []
        if let followers = user.followers, followers.contains(id){
            updatedFollowers = followers.filter{$0 != id}
        }else {
            updatedFollowers.append(id)
        }
        var newUpdate = user
        newUpdate.followers = updatedFollowers
        do {
            try await databaseService.updateUser(newUpdate)
            let updateUser = try await databaseService.fetchUser(id: newUpdate.id)
            onComplete(updateUser)
        } catch {
            print("Error al actualizar el usuario: \(error.localizedDescription)")
        }
    }
}
