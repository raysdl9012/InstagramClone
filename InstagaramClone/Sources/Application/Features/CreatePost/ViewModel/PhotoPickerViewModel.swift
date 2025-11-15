//
//  PhotoPickerViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine
import Photos
import UIKit


class PhotoPickerViewModel: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedItem: MediaItem? = nil  // Solo UN item
    @Published var isLoading = false
    
    private let imageManager = PHCachingImageManager()
    
    init() {
        requestPhotoLibraryAccess()
    }
    
    // MARK: - Photo Library Access
    /// Solicita acceso a la biblioteca de fotos
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.fetchMediaFromLibrary()
                case .denied, .restricted:
                    print("❌ Acceso denegado a la biblioteca de fotos")
                case .notDetermined:
                    print("⏳ Acceso no determinado")
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: - Fetch Media
    /// Obtiene todas las fotos y videos de la biblioteca
    func fetchMediaFromLibrary() {
        isLoading = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Obtener fotos y videos
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        
        var items: [MediaItem] = []
        
        assets.enumerateObjects { [weak self] asset, _, _ in
            guard let self = self else { return }
            
            let isVideo = asset.mediaType == .video
            
            // Crear MediaItem con PHAsset
            let item = MediaItem(
                id: asset.localIdentifier,
                thumbnail: nil,
                image: nil,
                isVideo: isVideo,
                duration: isVideo ? self.formatDuration(asset.duration) : nil,
                phAsset: asset
            )
            
            items.append(item)
            
            // Cargar thumbnail
            self.loadThumbnail(for: asset) { image in
                if let index = self.mediaItems.firstIndex(where: { $0.id == item.id }) {
                    self.mediaItems[index] = MediaItem(
                        id: item.id,
                        thumbnail: image,
                        image: image,
                        isVideo: item.isVideo,
                        duration: item.duration,
                        phAsset: item.phAsset
                    )
                }
            }
        }
        
        DispatchQueue.main.async {
            self.mediaItems = items
            self.isLoading = false
        }
    }
    
    // MARK: - Load Thumbnail
    /// Carga la miniatura de un asset
    private func loadThumbnail(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        let size = CGSize(width: 200, height: 200)
        
        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // MARK: - Load Full Size Image
    /// Carga la imagen en tamaño completo
    private func loadFullSizeImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        let targetSize = CGSize(width: 1080, height: 1080)
        
        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // MARK: - Selection Management
    /// Selecciona un item (reemplaza la selección anterior)
    func selectItem(_ item: MediaItem) {
        // Si ya está seleccionado, deseleccionar
        if selectedItem?.id == item.id {
            selectedItem = nil
            return
        }
        
        // Seleccionar el nuevo item
        selectedItem = item
        
        // Cargar imagen en alta calidad si tiene PHAsset
        if let phAsset = item.phAsset {
            loadFullSizeImage(for: phAsset) { [weak self] fullImage in
                guard let self = self else { return }
                
                // Actualizar con imagen en alta calidad
                self.selectedItem = MediaItem(
                    id: item.id,
                    thumbnail: item.thumbnail,
                    image: fullImage ?? item.image,
                    isVideo: item.isVideo,
                    duration: item.duration,
                    phAsset: item.phAsset,
                    aspectRatio: (item.thumbnail?.size.width ?? 1) / (item.thumbnail?.size.height ?? 1)
                )
            }
        }
    }
    
    /// Verifica si un item está seleccionado
    func isSelected(_ item: MediaItem) -> Bool {
        selectedItem?.id == item.id
    }
    
    // MARK: - Helper Methods
    /// Formatea la duración del video
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Selecciona una imagen capturada desde la cámara
    func selectCapturedMedia(media: MediaItem) {
        selectedItem = media
    }
}

struct MediaItem: Identifiable {
    let id: String
    let thumbnail: UIImage?
    let image: UIImage?
    let isVideo: Bool
    let duration: String?
    let phAsset: PHAsset?
    let videoURL: URL?
    var aspectRatio: CGFloat?
    init(id: String = UUID().uuidString,
         thumbnail: UIImage? = nil,
         image: UIImage? = nil,
         isVideo: Bool = false,
         duration: String? = nil,
         phAsset: PHAsset? = nil,
         videoURL: URL? = nil,
         aspectRatio: CGFloat? = nil) {
        self.id = id
        self.thumbnail = thumbnail
        self.image = image
        self.isVideo = isVideo
        self.duration = duration
        self.phAsset = phAsset
        self.videoURL = videoURL
        self.aspectRatio = aspectRatio
    }
}
