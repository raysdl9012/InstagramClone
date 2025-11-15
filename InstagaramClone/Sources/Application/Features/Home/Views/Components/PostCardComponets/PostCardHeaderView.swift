//
//  PostCardHeaderView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardHeaderView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var viewModel: HomeViewModel
    var post: PostEntity
    private let gradientColors: [Color] = [.red, .purple, .orange]
    
    private var author: UserEntity? {
        viewModel.authors[post.ownerId]
    }
    
    
    var body: some View {
        HStack {
            if let media = author?.profileImage {
                
                NavigationLink {
                    
                    if sessionManager.currentUser?.id == author?.id {
                        ProfileView()
                            .toolbar(.hidden, for: .tabBar)
                    }else {
                        ProfileView(publicUser: author)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    
                } label: {
                    RemoteImageView(media: media,
                                    placeholderImage: Image(systemName: "person.circle.fill"))
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: gradientColors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )    .clipped()
                }
                
            }else {
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.indigo.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Circle())
            }
            
            
            
            Text(author?.getFullName() ?? "Unknown User")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    PostCardHeaderView(post: PostEntity.mock[0])
        .environmentObject(HomeViewModel())
}



