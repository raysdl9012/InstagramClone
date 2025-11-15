//
//  PreviewPhotoGalleryView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PreviewPhotoGalleryView: View {
    
    var mediaItem: MediaItem
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Preview de la foto/video seleccionado
            if let image = mediaItem.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit() // Equivalente a .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity) // Solo limitamos el ancho, la altura es automática
                    .background(.black)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .id(mediaItem.id)
            } else {
                // Placeholder mientras carga
                Color.gray.opacity(0.3)
                    .frame(height: 350)
                    .overlay {
                        ProgressView()
                    }
                    .transition(.opacity)
            }
            
            // Indicador de tipo de media
            if mediaItem.isVideo {
                HStack(spacing: 6) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 12))
                    Text(mediaItem.duration ?? "")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.95)),
            removal: .opacity.combined(with: .scale(scale: 1.05))
        ))
    }
}

#Preview {
    PreviewPhotoGalleryView(mediaItem: MediaItem(id: "",
                                                 thumbnail: nil,
                                                 image: UIImage(named: "logo"),
                                                 isVideo: false,
                                                 duration: "", phAsset: nil))
}
