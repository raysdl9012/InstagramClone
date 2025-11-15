//
//  FullImageView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import Kingfisher

struct FullImageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let media: MultimediaEntity
    let placeholderImage: Image // Renombrado para mayor claridad
    
    // Inicializador conveniente
    init(media: MultimediaEntity,
         placeholderImage: Image = Image(systemName: "person.circle.fill")) {
        self.media = media
        self.placeholderImage = placeholderImage
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            KFImage(media.getMultimediaURL())
                .resizable()
                .placeholder {
                    placeholderImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(.white)
                        .foregroundColor(Color.blue)
                }
                .serialize(as: .PNG)
                .onSuccess({ result in
                    print(result)
                })
                .onFailure { error in
                    print(error)
                }
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300)))
                .loadDiskFileSynchronously(true)
                .background(.black)
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.animation(.easeIn(duration: 0.2)))
            
            Image(systemName: "xmark.circle.fill")
                .font(Font.system(size: 40))
                .foregroundStyle(Color.white)
                .background(.black.opacity(0.6))
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
    FullImageView(media: PostEntity.mock[0].media)
}

