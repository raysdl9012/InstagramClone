//
//  ProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showEditProfile: Bool = false
    @State private var selectedPost: PostEntity? = nil
    @State private var isSharingPresented: Bool = false
    @StateObject private var videoControlViewModel = VideoControlViewModel()
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    
    
    @State var publicUser: UserEntity? = nil
    @State var followersUpdate = -1
    
    private var isPublic: Bool {
        return publicUser != nil
    }
    
    private var follwersCount: Int {
        followersUpdate < 0 ? (profileUser.followers?.count ?? 0) : followersUpdate
    }
    
    private var profileUser: UserEntity {
        if let publicUser = publicUser {
            return publicUser
        } else {
            return sessionManager.currentUser ?? UserEntity.mock
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HeaderProfileView(postCount: viewModel.userPosts.count,
                                  followersCount: follwersCount,
                                  user: profileUser)
                
                ProfileInfoView(user: profileUser)
                
                if !isPublic {
                    ButtonsProfileView {
                        showEditProfile.toggle()
                    } onShare: {
                        
                    }
                } else {
                    Divider()
                        .padding(.vertical, 15)
                }
                
                if viewModel.isLoadingUserPosts && viewModel.userPosts.isEmpty {
                    ProgressView("Cargando publicaciones...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 50)
                } else if let error = viewModel.userPostsError {
                    ErrorProfilePostView(errrorMesasge: error) {
                        viewModel.fetchUserPosts(user: sessionManager.currentUser)
                    }
                } else if viewModel.userPosts.isEmpty {
                    EmptyStateProfileView()
                } else {
                    ImagesPublicationView(posts: viewModel.userPosts) { post in
                        selectedPost = post
                    }
                }
            }
            .navigationDestination(isPresented: $showEditProfile, destination: {
                EditProfileView()
            })
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.fetchUserPosts(user: profileUser)
            }
            .toolbar {
                
                principalToolbarItem(title: profileUser.name, size: 25)
                
                if !isPublic {
                    trailingToolbarItem (icon: "door.left.hand.open") {
                        sessionManager.signOut()
                    }
                }else{
                    trailingToolbarItem (icon: "person.line.dotted.person") {
                        Task {
                            await viewModel.updateProfileWithFollowers(id: sessionManager.currentUser!.id,
                                                                       to: profileUser) { user in
                                publicUser = user
                            }
                        }
                    }
                }
                
            }
            .fullScreenCover(item: $selectedPost) { post in
                if post.media.type == .image {
                    FullImageView(media: post.media)
                        .padding(20)
                        .environmentObject(videoControlViewModel)
                        .background(.black)
                } else if post.media.type == .video {
                    FullVideoPlayer(media: post.media)
                        .padding(20)
                        .cornerRadius(10)
                        .environmentObject(videoControlViewModel)
                        .background(.black)
                    
                }
            }
            .onAppear {
                viewModel.fetchUserPosts(user: profileUser)
            }
            .id(profileUser.id)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager(currentUser: UserEntity.mock))
}
