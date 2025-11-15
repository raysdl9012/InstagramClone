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


enum VideoDisplayMode {
    case normal    // usa el aspect ratio real
    case grid      // cuadrado (1:1)
}

struct ControlVideoPlayer: View {
    
    let videoURL: URL
    let displayMode: VideoDisplayMode
    let aspectRatio: CGFloat
    @StateObject var manager: VideoPlayerManager
    @EnvironmentObject var videoControlViewModel: VideoControlViewModel
    
    init(videoURL: URL, displayMode: VideoDisplayMode = .normal, aspectRatio: CGFloat = 16/9) {
        self.videoURL = videoURL
        self.displayMode = displayMode
        self.aspectRatio = aspectRatio
        _manager = StateObject(wrappedValue: VideoPlayerStore.shared.manager(for: videoURL))
    }
    
    private func onDraggin(dragging: Bool){
        if !dragging{
            let newTime = CMTime(seconds: manager.currentTime,
                                 preferredTimescale: 500)
            manager.seek(time: newTime)
            manager.play()
        }
        if dragging {
            manager.pause()
        }
    }
    
    private func actionPlayPause(){
        manager.isPlaying.toggle()
        if manager.isPlaying {
            videoControlViewModel.currentVideoPlayer = videoURL
            manager.play()
        }else{
            manager.pause()
        }
    }
    
    var body: some View {
        
        
        ZStack(alignment: .center) {
            //Player
            VideoPlayerView(player: manager.getPlayer(), isPlaying: $manager.isPlaying)
                .background(.black)
                .onTapGesture {
                    actionPlayPause()
                }
                .modifier(VideoAspectModifier(mode: displayMode,
                                              aspectRatio: manager.videoAspectRatio))
                .clipped()
            
            // ImagePlay
            if !manager.isPlaying, displayMode == .normal {
                ControlPlayComponent()
            }
            
            if displayMode == .normal {
                VStack(spacing: 0) {
                    Spacer()
                    VideoProgressBarView(isDragging: $manager.isPlaying,
                                         currentTime: $manager.currentTime,
                                         totalDuration: manager.totalDuration) { dragging in
                        onDraggin(dragging: dragging)
                    }.padding(.horizontal, 10)
                }
            }
        }
        .onAppear {
            manager.videoAspectRatio = aspectRatio
        }
        .background(.black)
        .clipped()
        .onDisappear {
            manager.isPlaying = false
            manager.pause()
        }
        .onChange(of: videoControlViewModel.currentVideoPlayer) { value in
            
            guard let newURL = value else { return }
            
            if newURL != videoURL {
                manager.isPlaying = false
                manager.pause()
            }
        }
    }
}

#Preview {
    /*
     let urlV = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(5).mp4?alt=media&token=71e4113c-6f4c-4438-a37e-6de9a5e32875")!
     */
    let urlH = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(2).mp4?alt=media&token=d838859d-475d-49a5-8432-9462988fbee9")!
    
    ControlVideoPlayer(videoURL: urlH)
        .environmentObject(VideoControlViewModel())
    
}
