//
//  CreateViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine
import Photos


enum TypeCreatePost {
    case post
    case reel
}

class CreatePostViewModel: ObservableObject {
    
    @Published var media: MediaItem?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPostUploaded = false
    @Published var typePost: TypeCreatePost = .post
    
    // Dependencias inyectadas
    private let storageService: FIRStorageServiceProtocol
    private let databaseService: FIRDatabaseServiceProtocol
    private let sessionManager: SessionManager
    
    init(storageService: FIRStorageServiceProtocol = FIRStorageServices.shared,
         databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared,
         sessionManager: SessionManager) {
        self.storageService = storageService
        self.databaseService = databaseService
        self.sessionManager = sessionManager
    }
    
    func createPost() {
        
        guard let media = media else {
            errorMessage = "Select an file to upload"
            return
        }
        
        
        if typePost == .reel, !media.isVideo {
            errorMessage = "To create reels only you can select a video."
            return
        }
        
        guard let user = sessionManager.user,
              let currentUser = sessionManager.currentUser else {
            errorMessage = "No se pudo obtener la información del usuario."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let aspectRatio = media.aspectRatio ?? 1.0
        let nameCollection = typePost == .post ? FIR_COLLECTION_POSTS : FIR_COLLECTION_REELS
        
        Task {
            let filePath = "\(nameCollection)/\(user.uid)/\(UUID().uuidString).jpg"
            if media.isVideo {
                if let url = media.videoURL {
                    
                    await createMediaFromURL(url: url, filePath: filePath, user: currentUser, aspectRatio: aspectRatio)
                    
                } else if let phAsset = media.phAsset {
                    await createMediaFromURLFromPhAsset(phAsset: phAsset,
                                                  filePath: filePath,
                                                  aspectRatio: aspectRatio,
                                                  currentUser: currentUser)
                }
            }else {
                await createImageFromURL(media: media,
                                         filePath: filePath,
                                         user: currentUser,
                                         aspectRatio: aspectRatio)
            }
            await MainActor.run {
                self.isLoading = false
            }
            
        }
    }
    
    private func createMediaFromURLFromPhAsset(phAsset: PHAsset, filePath: String, aspectRatio: CGFloat, currentUser: UserEntity) async{
        do {
            if typePost == .reel {
                let fileURL = try await storageService.uploadVideo(from: phAsset, path: filePath)
                let newReel = createReel(user: currentUser,
                                         fileURL: fileURL,
                                         filePath: filePath,
                                         type: .video,
                                         aspectRatio: aspectRatio)
                try await databaseService.createReel(newReel)
            }else {
                let fileURL = try await storageService.uploadVideo(from: phAsset, path: filePath)
                let newPost = createPost(user: currentUser,
                                         fileURL: fileURL,
                                         filePath: filePath,
                                         type: .video,
                                         aspectRatio: aspectRatio)
                try await databaseService.createPost(newPost)
            }
            await MainActor.run {
                self.isPostUploaded = true
            }
        } catch {
            if let storageError = error as? StorageError {
                self.errorMessage = storageError.localizedDescription
            } else if let dbError = error as? DatabaseError {
                self.errorMessage = dbError.localizedDescription
            } else {
                self.errorMessage = "Ocurrió un error inesperado: \(error.localizedDescription)"
            }
        }
    }
    
    
    private func createImageFromURL(media:MediaItem, filePath: String, user:UserEntity, aspectRatio: CGFloat) async{
        guard let imageToUpload = media.image else {
            errorMessage = "Select an file to upload"
            return
        }
        do {
            let fileURL = try await storageService.uploadImage(imageToUpload, path: filePath)
            if typePost == .reel {
                let newReel = createReel(user: user,
                                         fileURL: fileURL,
                                         filePath: filePath,
                                         type: .video,
                                         aspectRatio: aspectRatio)
                try await databaseService.createReel(newReel)
            } else {
                let newPost = createPost(user: user,
                                         fileURL: fileURL,
                                         filePath: filePath, type: .image,
                                         aspectRatio: aspectRatio)
                try await databaseService.createPost(newPost)
            }
            await MainActor.run {
                self.isPostUploaded = true
            }
            
        }catch {
            if let storageError = error as? StorageError {
                self.errorMessage = storageError.localizedDescription
            } else if let dbError = error as? DatabaseError {
                self.errorMessage = dbError.localizedDescription
            } else {
                self.errorMessage = "Ocurrió un error inesperado: \(error.localizedDescription)"
            }
        }
    }
    
    private func createMediaFromURL(url:URL, filePath: String, user:UserEntity, aspectRatio: CGFloat) async{
        do {
            let fileURL = try await storageService.uploadVideo(from: url, path: filePath)
            if typePost == .reel {
                let newReel = createReel(user: user,
                                         fileURL: fileURL,
                                         filePath: filePath,
                                         type: .video,
                                         aspectRatio: aspectRatio)
                try await databaseService.createReel(newReel)
            }else {
                let newPost = createPost(user: user,
                                         fileURL: fileURL,
                                         filePath: filePath,
                                         type: .video,
                                         aspectRatio: aspectRatio)
                try await databaseService.createPost(newPost)
            }
            
            await MainActor.run {
                self.isPostUploaded = true
            }
        }catch {
            
        }
    }
    
    private func createReel(user: UserEntity,
                            fileURL: URL,
                            filePath: String,
                            type: MultimediaType,
                            aspectRatio: CGFloat) -> ReelEntity {
        let multimedia = MultimediaEntity(id: UUID(),
                                          url: fileURL.absoluteString,
                                          type: type,
                                          aspectRatio: aspectRatio)
        let newReel = ReelEntity(ownerId: user.id,
                                 likes: [],
                                 media: multimedia)
        return newReel
    }
    
    private func createPost(user: UserEntity,
                            fileURL: URL,
                            filePath: String,
                            type: MultimediaType,
                            aspectRatio: CGFloat) -> PostEntity {
        let multimedia = MultimediaEntity(id: UUID(),
                                          url: fileURL.absoluteString,
                                          type: type,
                                          aspectRatio: aspectRatio)
        let newPost = PostEntity(ownerId: user.id,
                                 likes: [],
                                 media: multimedia)
        return newPost
    }
    
}
