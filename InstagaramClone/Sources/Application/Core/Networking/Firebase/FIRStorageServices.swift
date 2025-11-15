//
//  FIRStorageServices.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit
import Photos

// MARK: - Enum para errores de Storage
enum StorageError: LocalizedError {
    case imageNotFound
    case imageConversionFailed
    case uploadFailed(String)
    case downloadURLNotFound
    case unknown(String)
    case videoExportFailed
    case urlNotFound
    var errorDescription: String? {
        switch self {
        case .imageNotFound:
            return "No se encontró la imagen para subir."
        case .imageConversionFailed:
            return "No se pudo procesar la imagen seleccionada."
        case .uploadFailed(let message):
            return "Error al subir la imagen: \(message)"
        case .downloadURLNotFound:
            return "No se pudo obtener la URL de la imagen subida."
        case .unknown(let message):
            return "Error en el almacenamiento: \(message)"
        case .videoExportFailed:
            return "Error al exportar el video."
        case .urlNotFound:
            return "No se encontró la URL correspondiente."
        }
    }
}

// MARK: - Protocolo del Servicio de Storage
protocol FIRStorageServiceProtocol {
    func uploadImage(_ image: UIImage, path: String) async throws -> URL
    func uploadVideo(from localURL: URL, path: String) async throws -> URL
    func uploadVideo(from asset: PHAsset, path: String) async throws -> URL
    func uploadProfileImage(_ image: UIImage, for userID: String) async throws -> URL
}

// MARK: - Implementación del Servicio de Firebase Storage
class FIRStorageServices: FIRStorageServiceProtocol {
    
    static let shared = FIRStorageServices()
    private let storage = Storage.storage()
    
    private init() {} // Singleton
    
    func uploadImage(_ image: UIImage, path: String) async throws -> URL {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.imageConversionFailed
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let metadataRef = storage.reference(withPath: path)
            _ = try await metadataRef.putDataAsync(imageData, metadata: metadata)
            
            // Obtenemos la URL de descarga pública
            let downloadURL = try await metadataRef.downloadURL()
            return downloadURL
        } catch {
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }
    
    func uploadVideo(from asset: PHAsset, path: String) async throws -> URL {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                guard let avURLAsset = avAsset as? AVURLAsset else {
                    continuation.resume(throwing: StorageError.videoExportFailed)
                    return
                }
                do {
                    // Copiamos el archivo temporalmente para subirlo
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
                    try FileManager.default.copyItem(at: avURLAsset.url, to: tempURL)
                    let metadata = StorageMetadata()
                    metadata.contentType = "video/mp4"
                    let storageRef = self.storage.reference(withPath: path)
                    storageRef.putFile(from: tempURL, metadata: metadata) { metadata, error in
                        if let error = error {
                            continuation.resume(throwing: StorageError.uploadFailed(error.localizedDescription))
                            return
                        }
                        
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                continuation.resume(throwing: StorageError.uploadFailed(error.localizedDescription))
                                return
                            }
                            guard let url = url else {
                                continuation.resume(throwing: StorageError.urlNotFound)
                                return
                            }
                            continuation.resume(returning: url)
                        }
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func uploadVideo(from localURL: URL, path: String) async throws -> URL {
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        let storageRef = storage.reference(withPath: path)
        do {
            // Subimos el archivo directamente desde la URL local
            _ = try await storageRef.putFileAsync(from: localURL, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL
            
        } catch {
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }
    
    func uploadProfileImage(_ image: UIImage, for userID: String) async throws -> URL {
        let path = "\(FIR_PROFILE_IMAGE_STORAGE_BUCKET)/\(userID)/profile.jpg"
        do {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw StorageError.imageConversionFailed
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let metadataRef = storage.reference(withPath: path)
            _ = try await metadataRef.putDataAsync(imageData, metadata: metadata)
            
            let downloadURL = try await metadataRef.downloadURL()
            return downloadURL
        } catch {
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }
}
