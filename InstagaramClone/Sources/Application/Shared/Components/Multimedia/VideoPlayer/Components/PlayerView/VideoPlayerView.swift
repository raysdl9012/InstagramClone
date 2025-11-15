//
//  VideoPlayerView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VideoPlayerView: View {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    
    var body: some View {
        VideoPlayerViewRespresentable(player: player,
                                      isPlaying: $isPlaying)
    }
}

#Preview {
    
    let urlV = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(5).mp4?alt=media&token=71e4113c-6f4c-4438-a37e-6de9a5e32875")!
    /*
    let urlH = URL(string: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(2).mp4?alt=media&token=d838859d-475d-49a5-8432-9462988fbee9")!
    */
    VideoPlayerView(player: AVPlayer(url: urlV),
                    isPlaying: .constant(true))
}
