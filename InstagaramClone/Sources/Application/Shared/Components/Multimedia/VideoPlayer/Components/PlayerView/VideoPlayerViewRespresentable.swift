//
//  VideoPlayerViewRespresentable.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//


import SwiftUI
import AVKit
import AVFoundation

// MARK: - 1. AVPlayerRepresentable (Motor de Video)

struct VideoPlayerViewRespresentable: UIViewRepresentable {
    
    var player: AVPlayer
    @Binding var isPlaying: Bool


    func makeUIView(context: Context) -> UIView {
        // Usamos la subclase PlayerUIView para manejar el layout de la capa
        let view = PlayerUIView()
        view.player = player
        
        // Asignamos el coordinador y el estado inicial
        context.coordinator.playerView = view
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Actualizamos el estado de reproducción y mute cuando los Bindings cambian
        isPlaying ? player.play() : player.pause()
    }
    
    // Coordinador para manejar eventos (Looping)
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Subclase PlayerUIView (CRÍTICO para la sincronización visual)
    
    class PlayerUIView: UIView {
        
        // Asegura que la capa subyacente sea AVPlayerLayer
        override static var layerClass: AnyClass {
            return AVPlayerLayer.self
        }
        
        // Propiedad de conveniencia para acceder al AVPlayerLayer
        var playerLayer: AVPlayerLayer {
            return layer as! AVPlayerLayer
        }
        
        var player: AVPlayer? {
            get { playerLayer.player }
            set { playerLayer.player = newValue }
        }
        
        init() {
            super.init(frame: .zero)
            // CRÍTICO: Configura cómo el video llena la capa (rellena y recorta)
            playerLayer.videoGravity = .resizeAspectFill
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // CRÍTICO: Forzamos la capa de video a rellenar el frame en cada ciclo de layout.
            // Esto resuelve el problema de "suena pero no se ve".
            playerLayer.frame = bounds
        }
    }
    
    // MARK: - Coordinator (Lógica de Looping)
    
    class Coordinator: NSObject {
        var parent: VideoPlayerViewRespresentable
        var playerView: PlayerUIView?
        
        init(parent: VideoPlayerViewRespresentable) {
            self.parent = parent
            super.init()
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: parent.player.currentItem)
        }
        
        @objc func playerItemDidReachEnd(notification: Notification) {
            parent.player.seek(to: .zero)
            parent.player.play()
            parent.isPlaying = true
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
