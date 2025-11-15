//
//  ImagesPublicationView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ImagesPublicationView: View {
    
    var posts: [PostEntity]
    var onClick: (PostEntity) -> Void
    
    private let gridLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        LazyVGrid(columns: gridLayout, spacing: 5) {
            ForEach(posts) { post in
                MultimediaView(media: post.media, displayMode: .grid)
                    .id(post.media.id)
                    .overlay(
                        Color.black.opacity(0.001) // Invisible pero clickeable
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onClick(post)
                            }
                    ).aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

#Preview {
    ImagesPublicationView(posts: PostEntity.mock) { post in
        
    }
    .environmentObject(VideoControlViewModel())
    .padding()
    
}
