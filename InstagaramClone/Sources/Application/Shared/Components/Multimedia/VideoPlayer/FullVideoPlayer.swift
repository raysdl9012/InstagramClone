//
//  FullVideoPlayer.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct FullVideoPlayer: View {
    
    @Environment(\.dismiss) var dismiss
    
    var media: MultimediaEntity
    
    init(media: MultimediaEntity) {
        self.media = media
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if let url = media.getMultimediaURL() {
                ControlVideoPlayer(videoURL: url, displayMode: .normal, aspectRatio: media.aspectRatio)
                    .id(media.id)
                    .background(.black)
                    .ignoresSafeArea()
            }
            
            Image(systemName: "xmark.circle.fill")
                .font(Font.system(size: 40))
                .foregroundStyle(Color.white)
                .background(.indigo.opacity(0.6))
                .clipShape(Circle())
                .padding(30)
                .onTapGesture{
                    dismiss()
                }
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

#Preview {

    FullVideoPlayer(media: ReelEntity.mock[0].media)
        .environmentObject(VideoControlViewModel())
}
