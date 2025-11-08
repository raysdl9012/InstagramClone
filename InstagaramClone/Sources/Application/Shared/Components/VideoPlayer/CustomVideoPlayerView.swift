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
    
    @Binding var isFocused: Bool
    @State private var isPlaying: Bool = false
    @ObservedObject var manager: VideoPlayerManager
    
    var onClick: () -> Void
    
    init(manager: VideoPlayerManager,
         videoURL: URL,
         isFocused: Binding<Bool>,
         onClick: @escaping () -> Void) {
        // Inicializar todas las propiedades de almacenamiento
        self.manager = manager
        self.videoURL = videoURL
        self.onClick = onClick
        // Inicializar el Binding (proyección)
        _isFocused = isFocused
    }
    
    
    private func getHeight(width: CGFloat) -> CGFloat {
        if manager.videoAspectRatio < 1 {
            return width * 0.9 / manager.videoAspectRatio
        }else {
            return width / manager.videoAspectRatio
        }
    }
    
    private func getWidth(width: CGFloat) -> CGFloat {
        if manager.videoAspectRatio < 1 {
            return width * 0.9
        }else {
            return width
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                AVPlayerRepresentable(player: manager.player, isPlaying: $isPlaying)
                    .frame(height: getHeight(width: geometry.size.width))
                    .frame(maxWidth: getWidth(width: geometry.size.width))
                    .onTapGesture {
                        isPlaying.toggle()
                        if isPlaying {
                            onClick()
                            manager.pause()
                        }else {
                            manager.play()
                        }
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
                        isDragging: $manager.isDragging,
                        currentTime: $manager.currentTime,
                        player: manager.player,
                        totalDuration: manager.totalDuration
                    )
                    .frame(height: 3)
                }
                .padding(.bottom, 16)
            }
        }
        .onChange(of: isFocused, perform: { newValue in
            print("New focus value: \(newValue)")
            
            if !newValue {
                isPlaying = false
                manager.pause()
            }
            
        })
        .background(.black)
        .clipped()
        .aspectRatio(manager.videoAspectRatio, contentMode: .fit)
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback,
                                                                mode: .default,
                                                                options: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                fatalError("Controlar el error de audio session")
            }
        }
        .onDisappear {
            manager.pause()
        }
    }
}

#Preview {
    NavigationStack {
        let sampleURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/feb759a2-c018-443e-afff-9c2aba5e2fe3.MP4?alt=media&token=805f8ffc-ecfa-4964-ab33-1c8a109292d7")!
        let manager = VideoPlayerManager(videoID: UUID(), videoURL: sampleURL)
        CustomVideoPlayer(manager: manager, videoURL: sampleURL, isFocused: .constant(false)) {
            
        }
    }
}
