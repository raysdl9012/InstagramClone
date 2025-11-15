//
//  RemoteImageView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    
    let media: MultimediaEntity
    let placeholderImage: Image
    
    var displayMode: VideoDisplayMode = .normal
    
    // Inicializador conveniente
    init(media: MultimediaEntity,
         placeholderImage: Image = Image(systemName: "photo"),
         displayMode: VideoDisplayMode = .normal) {
        self.media = media
        self.displayMode = displayMode
        self.placeholderImage = placeholderImage
    }
    
    var body: some View {
        VStack {
            KFImage(media.getMultimediaURL())
                .placeholder {
                    placeholderImage
                        .resizable()
                        .frame(width: 100, height: 100)
                        .background(.clear)
                        .foregroundColor(.indigo.opacity(0.5))
                }
                .resizable()
                .modifier(VideoAspectModifier(mode: displayMode,
                                              aspectRatio: media.aspectRatio))
                .frame(maxWidth: .infinity,
                       maxHeight: calculatedHeight(for: UIScreen.screenWidth))
                .background(.black)
                .clipped()
                .transition(.opacity.animation(.easeIn(duration: 0.2)))
        }
        .frame(maxWidth: .infinity)
        .background(.red)
    }
    
    private func calculatedHeight(for width: CGFloat) -> CGFloat {
        let height = width / media.aspectRatio
        return min(height, maxDisplayHeight)
    }
    
    private var maxDisplayHeight: CGFloat {
        UIScreen.main.bounds.height * 0.8
    }
}

#Preview {
    RemoteImageView(media: PostEntity.mock[1].media)
    
    
}
