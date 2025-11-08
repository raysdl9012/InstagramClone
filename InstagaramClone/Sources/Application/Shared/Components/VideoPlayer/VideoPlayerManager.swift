//
//  VideoPlayerManager.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import AVFoundation
internal import Combine
import UIKit

class VideoPlayerManager: ObservableObject {
    
    let player: AVPlayer
    let videoID: UUID
    let defaultHeight: Bool
    
    @Published var isDragging: Bool = false
    @Published var currentTime: Double = 0
    @Published var totalDuration: Double = 0
    @Published var videoAspectRatio: CGFloat = 0.5
    @Published var isAssetPropertiesLoaded: Bool = false
    
    init(videoID: UUID, videoURL: URL, defaultHeight: Bool = false) {
        self.defaultHeight = defaultHeight
        self.videoID = videoID
        self.player = AVPlayer(url: videoURL)
        self.setValueToAspetRadio(value: 0.5)
        Task {
            self.setupPlayerObservers()
            await self.loadAssetProperties(videoURL: videoURL)
        }
    }
    
    public func pause() {
        player.pause()
    }
    
    public func play() {
        player.play()
    }
    
    private func setupPlayerObservers() {
        // Observador de tiempo (actualiza la barra de progreso) - Sin cambios aquí
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
                                       queue: .main) { time in
            guard !self.isDragging else {
                return
            }
            self.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    @MainActor
    private func loadAssetProperties(videoURL: URL) async {
        let asset = AVAsset(url: videoURL)
        do {
            // 1. Cargar 'tracks' (para el aspecto) y 'duration' (para la duración total)
            // Ambas se cargan en paralelo.
            let (tracks, duration) = try await asset.load(.tracks, .duration)
            
            // 2. Publicar la duración total
            await MainActor.run {
                self.totalDuration = duration.seconds
            }
            // 3. Calcular y publicar el Aspect Ratio
            if let videoTrack = tracks.first(where: { $0.mediaType == .video }) {
                // Cargar el tamaño natural
                let size = try await videoTrack.load(.naturalSize)
                
                let aspectRatio = size.height == 0 ? 1.0 : size.width / size.height
                
                // Actualizar el estado del aspecto
                await MainActor.run {
                    setValueToAspetRadio(value: aspectRatio)
                }
                
            } else {
                await MainActor.run {
                    setValueToAspetRadio(value: 1.0)
                }
            }
        } catch {
            await MainActor.run {
                self.totalDuration = 0.0
                setValueToAspetRadio(value: 1.0)
            }
        }
    }
    
    private func setValueToAspetRadio(value: CGFloat) {
        
        if defaultHeight {
            videoAspectRatio = UIScreen.screenWidth / UIScreen.screenHeight
        }else {
            self.videoAspectRatio = value
        }
        self.isAssetPropertiesLoaded = true
    }
    
}
