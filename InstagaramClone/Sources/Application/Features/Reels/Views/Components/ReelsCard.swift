//
//  ReelsCard.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ReelsCard: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var viewModel: ReelsViewModel
    @EnvironmentObject var videoReelsViewModel: VideoControlViewModel
    @EnvironmentObject var viewModelComments: CommentViewModel
    @State private var isCommentSheetPresented: Bool = false
    
    var reel: ReelEntity
    
    private var isLiked: Bool {
        reel.likes.contains(sessionManager.currentUser?.id ?? "")
    }
    
    var body: some View {
        if let url =  reel.media.getMultimediaURL() {
            ZStack(alignment: .trailing) {
                ControlVideoPlayer(videoURL: url,
                                   displayMode: .normal,
                                   aspectRatio: reel.media.aspectRatio)
                
                VStack {
                    Spacer()
                    ReelsInteractiveView(reel: reel,
                                         userLike: isLiked,
                                         reelComments: viewModelComments.comments.count) {
                        
                        Task {
                            await viewModel.updateReelsBy(like: sessionManager.currentUser?.id ?? "",
                                                          reel: reel)
                        }
                        
                    } onComment: {
                        isCommentSheetPresented = true
                    }
                    .padding(.trailing, 1)
                    Spacer()
                }
            }
            .sheet(isPresented: $isCommentSheetPresented) {
                CommentsView(postId: reel.id, author: sessionManager.currentUser!) {
                    viewModelComments.fetchComments(forPostWithId: reel.id)
                }
                .environmentObject(viewModelComments)
            }
            .task {
                viewModelComments.fetchComments(forPostWithId: reel.id)
            }
            .background(.black)
            
        }else {
            EmptyView()
                .background(.black)
                .frame(height: UIScreen.screenHeight*0.9)
        }
    }
}


#Preview {
    ReelsCard(reel: ReelEntity.mock.first!)
        .environmentObject(ReelsViewModel())
        .environmentObject(SessionManager())
        .environmentObject(VideoControlViewModel())
        .environmentObject(CommentViewModel())
}
