//
//  CustomVideoPlayerView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import SwiftUI
import AVKit
import AVFoundation

struct CustomVideoPlayer: View {
    let videoURL: URL
    @State private var player: AVPlayer
    @State private var isPlaying: Bool = false
    
    // Estados para la barra de progreso y arrastre
    @State private var totalDuration: Double = 0
    @State private var currentTime: Double = 0
    @State private var isDragging: Bool = false
    @State private var videoAspectRatio: CGFloat = 16.0 / 9.0
    
    // Inicializador seguro (sin cambios)
    init(videoURL: URL) {
        self.videoURL = videoURL
        let initialPlayer = AVPlayer(url: videoURL)
        _player = State(initialValue: initialPlayer)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }catch {
            fatalError("Este es un error a controlar")
        }
    }
    
    private func controlPlayPause() {
        if isPlaying {
            player.pause()
        }else {
            player.play()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                AVPlayerRepresentable(player: $player, isPlaying: $isPlaying)
                    .frame(height: geometry.size.width / videoAspectRatio)
                    .onTapGesture {
                        isPlaying.toggle()
                        controlPlayPause()
                    }
                
                if !isPlaying {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 5)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    VideoProgressBarView(
                        isDragging: $isDragging,
                        currentTime: $currentTime,
                        player: player,
                        totalDuration: totalDuration
                    )
                    .frame(height: 3)
                }
                .padding(.bottom, 16)
            }
        }
        .background(.black)
        .aspectRatio(videoAspectRatio, contentMode: .fit)
        .onAppear {
            setupPlayerObservers(player: player)
        }
        .onDisappear {
            player.pause()
        }
    }
}

extension CustomVideoPlayer {
    // MARK: - Lógica de Observadores y Ratio
    private func setupPlayerObservers(player: AVPlayer) {
        // Observador de tiempo (actualiza la barra de progreso) - Sin cambios aquí
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
            guard !isDragging else { return }
            self.currentTime = CMTimeGetSeconds(time)
        }
        
        // **NUEVA IMPLEMENTACIÓN:** Usando async/await y nuevas APIs
        Task { // Iniciamos una tarea asíncrona
            guard let currentItem = player.currentItem else { return }
            let asset = currentItem.asset
            
            do {
                // 1. Carga asíncrona de duración y tracks (más moderno que loadValuesAsynchronously)
                // Ya no es necesario llamar explícitamente a loadValuesAsynchronously
                // Puedes acceder a las propiedades directamente después de cargarlas.
                
                // 2. Obtener Duración (CORREGIDO: Usando .duration.seconds en lugar de CMTimeGetSeconds)
                let duration = try await asset.load(.duration)
                
                // 3. Obtener Tracks (CORREGIDO: Usando el nuevo método de carga asíncrona)
                let tracks = try await asset.load(.tracks)
                
                // Aseguramos la actualización en el hilo principal
                await MainActor.run {
                    self.totalDuration = duration.seconds
                    
                    // 4. Obtener Aspect Ratio (CORREGIDO: Obteniendo la información de la pista de video)
                    if let videoTrack = tracks.first(where: { $0.mediaType == .video }) {
                        
                        // 5. Tamaño Natural (CORREGIDO: Usando el nuevo método load(.naturalSize))
                        Task {
                            let size = try await videoTrack.load(.naturalSize)
                            await MainActor.run {
                                self.videoAspectRatio = size.width / size.height
                            }
                        }
                    }
                }
            } catch {
                print("Error al cargar propiedades del asset: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        
        let sampleURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/feb759a2-c018-443e-afff-9c2aba5e2fe3.MP4?alt=media&token=805f8ffc-ecfa-4964-ab33-1c8a109292d7")!
        CustomVideoPlayer(videoURL: sampleURL)
    }
}
