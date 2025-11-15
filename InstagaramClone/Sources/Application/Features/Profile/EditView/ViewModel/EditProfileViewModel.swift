//
//  EditProfileViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import UIKit
internal import Combine

class EditProfileViewModel: ObservableObject {
    
    // Dependencias inyectadas
    private let databaseService: FIRDatabaseServiceProtocol
    private let storageService: FIRStorageServiceProtocol
    
    
    // Propiedades publicadas para la vista (el formulario)
    @Published var name = ""
    @Published var lastName = ""
    @Published var bio = ""
    @Published var selectedImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSaved = false
    
    // Guardamos la URL inicial para saber si la imagen cambió
    private var initialProfileImageURL: String?
    private var currentUser: UserEntity?
    
    init(databaseService: FIRDatabaseServiceProtocol = FIRDatabaseService.shared,
         storageService: FIRStorageServiceProtocol = FIRStorageServices.shared) {
        self.databaseService = databaseService
        self.storageService = storageService
        
    }
    
    public func loadCurrentUserData(user: UserEntity?) {
        guard let user = user else { return }
        self.currentUser = user
        self.name = user.name
        self.lastName = user.lastName
        self.bio = user.description
        self.initialProfileImageURL = user.profileImage?.url
    }
    
    func updateUserProfile() async {
        guard let appUser = self.currentUser else {
            errorMessage = "No se pudo obtener la información del usuario."
            return
        }
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            var newProfileImageURL: String = ""
            var aspectRatio: CGFloat = 1.0
            
            if let newImage = selectedImage {
                let url = try await storageService.uploadProfileImage(newImage, for: appUser.id)
                newProfileImageURL = url.absoluteString
                aspectRatio = newImage.size.width / newImage.size.height
            }
            var updatedUser = appUser
            updatedUser.name = name
            updatedUser.lastName = lastName
            updatedUser.description = bio
            if !newProfileImageURL.isEmpty {
                let media = MultimediaEntity(url: newProfileImageURL, type: .image, aspectRatio: aspectRatio)
                updatedUser.profileImage = media
            }
            try await databaseService.updateUser(updatedUser)
            await MainActor.run {
                self.isSaved = true
            }
            
        } catch {
            if let dbError = error as? DatabaseError {
                self.errorMessage = dbError.localizedDescription
            } else if let storageError = error as? StorageError {
                self.errorMessage = storageError.localizedDescription
            } else {
                self.errorMessage = "Error al guardar los cambios: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            isLoading = false
        }
    }
}
