//
//  NewPostView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import PhotosUI // Para el selector de fotos/videos
import AVKit // Para reproducir el video seleccionado


struct CreatePostView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private let sessionManager: SessionManager
    
    var onCreatePostEnded: () -> Void = { }
    
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    @StateObject private var viewModel: CreatePostViewModel
    
    @State private var showCamera: Bool = false
    
    init(sessionManager: SessionManager, onCreatePostEnded: @escaping () -> Void = { } ) {
        self.sessionManager = sessionManager
        self.onCreatePostEnded = onCreatePostEnded
        self._viewModel = StateObject(wrappedValue: CreatePostViewModel(sessionManager: sessionManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(){
                ScrollView() {
                    
                    SelectionPostView(typePost: $viewModel.typePost)
                    
                    PreviewGroupView()
                        .environmentObject(photoPickerViewModel)
                    
                    MediaGridView(showCamera: $showCamera)
                        .environmentObject(photoPickerViewModel)
                    Spacer()
                }
                
                if viewModel.isLoading {
                    VStack() {
                        Spacer()
                        HStack{
                            Spacer()
                            ProgressView("upload post...")
                                .padding()
                                .cornerRadius(10)
                                .scaleEffect(1.2)
                                .tint(Color.yellow.opacity(0.8))
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(Color.black.opacity(0.7))
                }
            }
            
            .toolbar {
                leadingToolbarItem(icon: "xmark"){
                    dismiss()
                }
                principalToolbarItem(title: "New")
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.media = photoPickerViewModel.selectedItem
                        viewModel.createPost()
                    }
                    .disabled(photoPickerViewModel.selectedItem == nil)
                }
            }
            .disabled(viewModel.isLoading)
            .toolbar(.hidden, for: .tabBar)
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            })
            .onChange(of: viewModel.isPostUploaded) { success in
                if success {
                    dismiss()
                    onCreatePostEnded()
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView { mediaItem in
                    photoPickerViewModel.selectCapturedMedia(media: mediaItem)
                }
            }
        }
    }
}

#Preview {
    CreatePostView(sessionManager: SessionManager())
}
