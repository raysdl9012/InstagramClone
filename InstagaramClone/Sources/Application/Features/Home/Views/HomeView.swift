//
//  HomeView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    @State private var showNewPost = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.posts) { post in
                            PostCardView(post: post)
                                .id(post.id)
                        }
                        
                        Color.clear
                            .frame(height: 20)
                            .onAppear {
                                viewModel.loadMorePosts()
                            }
                        
                        // Indicador de carga para la paginación
                        if viewModel.isLoadingMore {
                            HStack {
                                ProgressView()
                                    .padding()
                                Text("loadin...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchPosts()
                }
                .task {
                    if viewModel.posts.isEmpty {
                        viewModel.fetchPosts()
                    }
                }
                .toolbar {
                    leadingToolbarItem {
                        showNewPost.toggle()
                    }
                    principalToolbarItem(title: "InstaClone")
                }
                .navigationDestination(isPresented: $showNewPost) {
                    CreatePostView(sessionManager: sessionManager) {
                        viewModel.fetchPosts()
                    }
                    .navigationBarBackButtonHidden()
                }
                
                // SImpleLoading
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView("Loading posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(UIColor.systemGroupedBackground))
                }
                
                // ErrorView
                if let errorMessage = viewModel.errorMessage, viewModel.posts.isEmpty {
                    ErrorLoadPostView(message: errorMessage) {
                        viewModel.fetchPosts()
                    }
                }
            }
            .environmentObject(viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct CircleBorderSegment: View {
    var start: CGFloat
    var end: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: start, to: end) // Dibuja solo una porción del círculo
            .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .rotationEffect(.degrees(-90)) // Comienza desde la parte superior
            .frame(width: 58, height: 58)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(VideoControlViewModel())
            .environmentObject(SessionManager())
    }
}
