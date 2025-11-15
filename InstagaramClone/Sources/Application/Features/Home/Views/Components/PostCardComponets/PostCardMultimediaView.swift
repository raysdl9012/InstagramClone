//
//  PostCardMultimediaView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import AVKit // Necesario para AVPlayer
import AVFoundation // Necesario para AVPlayerLayer

struct PostCardMultimediaView: View {
    
    var media: MultimediaEntity
    
    var body: some View {
        MultimediaView(media: media)
    }
}



#Preview {
    PostCardMultimediaView(media: PostEntity.mock[1].media)
        .environmentObject(VideoControlViewModel())
}









