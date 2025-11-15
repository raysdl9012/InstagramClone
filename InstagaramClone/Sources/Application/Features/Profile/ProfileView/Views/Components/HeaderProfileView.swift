//
//  HeaderProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct HeaderProfileView: View {
    let postCount: Int
    let followersCount: Int
    let user: UserEntity
    
    private var userMedia: MultimediaEntity {
        user.profileImage ?? MultimediaEntity(url: "", type: .image, aspectRatio: 1)
    }
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RemoteImageView(media: userMedia)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .foregroundColor(.gray)
            
            Spacer()

            HStack(spacing: 24) {
                VStack {
                    Text("\(postCount)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.indigo)
                    Text("Publicaciones")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
                VStack {
                    Text("\(followersCount)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.indigo)
                    Text("Seguidos")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
            }
        }
    }
}

#Preview {
    HeaderProfileView(postCount: 0, followersCount: 1, user: UserEntity.mock)
}
