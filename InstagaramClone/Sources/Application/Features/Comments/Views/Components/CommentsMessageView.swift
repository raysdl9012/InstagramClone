//
//  CommentsMessageView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 14/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CommentsMessageView: View {
    
    let userName: String
    let comment: String
    let media: MultimediaEntity
    
    
    var body: some View {
        VStack() {
            HStack(alignment: .top, spacing: 20) {
                RemoteImageView(media: media)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 5) {
                    Text(userName)
                        .foregroundStyle(.purple)
                    Text(comment)
                        .font(.caption)
                        .foregroundColor(.indigo)
                        .lineLimit(2)
                    Divider()
                        
                        .background(.black.opacity(0.7))
                        .padding(.top, 5)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
        }
    }
}

#Preview {
    CommentsMessageView(userName: "Reinner Steven Daza Leiva",
                        comment: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the momen",
                        media: UserEntity.mock.profileImage!) 
}
