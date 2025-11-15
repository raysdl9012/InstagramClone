//
//  MultimediaView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import SwiftUI

struct VideoAspectModifier: ViewModifier {
    let mode: VideoDisplayMode
    let aspectRatio: CGFloat
    
    func body(content: Content) -> some View {
        switch mode {
        case .normal:
            content
                .aspectRatio(aspectRatio, contentMode: .fit)
        case .grid:
            content
                .aspectRatio(1, contentMode: .fill)
                .clipped()
        }
    }
}
struct MultimediaView: View {
    
    var media: MultimediaEntity
    var displayMode: VideoDisplayMode = .normal
    
    var body: some View {
        VStack {
            switch media.type {
            case .image:
                RemoteImageView(media: media,
                                displayMode: displayMode)
            case .video:
                if let url = media.getMultimediaURL() {
                    ControlVideoPlayer(videoURL: url,
                                       displayMode: displayMode,
                                       aspectRatio: media.aspectRatio)
                }else {
                    EmptyView()
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .frame(height: 200)
                }
            }
        }
    }
}

#Preview {
    MultimediaView(media: PostEntity.mock[1].media)
        .environmentObject(VideoControlViewModel())
    
}
