//
//  MediaThumbnailView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct MediaThumbnailView: View {
    
    let item: MediaItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = item.thumbnail {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(item.aspectRatio ?? 1, contentMode: .fill)
                    .clipped()
            } else {
                Color.gray.opacity(0.3)
                    .aspectRatio(1, contentMode: .fill)
                    .overlay {
                        ProgressView()
                    }
            }
            
            // Indicador de video
            if item.isVideo {
                videoIndicator
            }
            
            // Indicador de selección
            if isSelected {
                selectionIndicator
            }
        }
        .overlay {
            if isSelected {
                Color.blue.opacity(0.3)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private var videoIndicator: some View {
        HStack {
            Image(systemName: "play.fill")
                .font(.system(size: 10))
            Text(item.duration ?? "")
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.black.opacity(0.6))
        .cornerRadius(4)
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    
    private var selectionIndicator: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 28, height: 28)
            
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(6)
    }
}


#Preview {
    MediaThumbnailView(item: MediaItem(id: "",
                                       thumbnail: nil,
                                       image: UIImage(named: "logo"),
                                       isVideo: false,
                                       duration: "", phAsset: nil),
                       isSelected: false) { }
}
