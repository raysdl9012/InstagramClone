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
        VStack {
            switch media.type {
                
            case .image:
                Image(media.url)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
            case .video:
                if let url = media.getVideoURL()  {
                    CustomVideoPlayer(videoURL: url)
                }else {
                    EmptyView()
                        .background(.black)
                        .frame(height: 200)
                }
            }
        }
    }
}

#Preview {
    PostCardMultimediaView(media: PostEntity.mock.first!.media)
}









