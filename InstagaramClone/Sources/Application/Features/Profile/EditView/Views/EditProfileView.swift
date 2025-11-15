//
//  EditProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var viewModel: EditProfileViewModel = EditProfileViewModel()
    
    @State private var isPickerPresented = false
    @State private var isShowingImagePicker = false
    @State private var showMultimedia: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    @State private var selectedPhoto: PhotosPickerItem?
        
    var body: some View {
        ZStack {
            Form {
                // Sección de Foto de Perfil
                HeaderEditView(imageUrl: sessionManager.currentUser?.profileImage?.getMultimediaURL(),
                               image: $viewModel.selectedImage,
                               showMultimedia: $showMultimedia)
                
                // Sección de Información Personal
                SectionFormDataUserView(isLoading: $viewModel.isLoading,
                                        name: $viewModel.name,
                                        lastName: $viewModel.lastName,
                                        bio: $viewModel.bio) {
                    Task {
                        await viewModel.updateUserProfile()
                    }
                }
            }
            
            if showMultimedia {
                SelectionMultimediaView(showMultimedia: $showMultimedia,
                                        isPickerPresented: $isPickerPresented,
                                        isShowingImagePicker: $isShowingImagePicker)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .animation(.easeInOut(duration: 0.4), value: showMultimedia)
        .toolbar {
            principalToolbarItem(title: "Edit Profile", size: 30)
        }
        .disabled(viewModel.isLoading)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        }, message: {
            Text(viewModel.errorMessage ?? "Error desconocido")
        })
        .fullScreenCover(isPresented: $isShowingImagePicker) {
            ImagePickerRepresentable(sourceType: .camera,
                                     selectedImage: $viewModel.selectedImage)
        }
        .photosPicker(
            isPresented: $isPickerPresented,
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.viewModel.selectedImage = uiImage
                }
            }
        }
        .onChange(of: viewModel.isSaved) { saved in
            if saved {
                guard let user = sessionManager.currentUser else {
                    return
                }
                sessionManager.fetchCurrentUser(uid: user.id)
                dismiss()
            }
        }
        .onAppear() {
            viewModel.loadCurrentUserData(user: sessionManager.currentUser)
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environmentObject(SessionManager())
    }
}
